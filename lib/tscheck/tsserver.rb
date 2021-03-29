require 'json'

module TSCheck
  class TSServer

    def initialize(options = {})
      @ts_base_path = options.fetch(:ts_base_path) { Dir.pwd }
      @ts_types_file_path = options.key?(:ts_types_file_path) ? File.join(@ts_base_path, options[:ts_types_file_path]) : nil
      @tsconfig_path = options[:tsconfig_path] && File.join(@ts_base_path, options[:tsconfig_path])
      @dummy_file_path = "#{@ts_base_path}/__typescript_schema_validator.ts"
    end

    def start_server
      @tsserver_out, cwrite = IO.pipe
      cread, @tsserver_in = IO.pipe

      @tsserver_pid = Process.spawn(
        # { 'TSS_LOG' => '-level verbose -logToFile true -file tsserver.log' },
        'tsserver',
        in: cread,
        out: cwrite,
        err: File::NULL
      )
      cwrite.close
      cread.close

      @seq = 0
    end

    def stop_server
      Process.kill('TERM', @tsserver_pid)
    end

    def check_type(json_string, type:, path: nil, default: false)
      import_statement =
        if path
          import_reference = default ? type : "{ #{type} }"
          fullpath = File.join(@ts_base_path, path)
          "import #{import_reference} from '#{fullpath}';"
        elsif @ts_types_file_path
          "import { #{type} } from '#{@ts_types_file_path}';"
        else
          ''
        end

      test_file_content = <<~TS
        #{import_statement}

        const actual: #{type} = #{json_string};
      TS

      open_arguments = { file: @dummy_file_path, fileContent: test_file_content }
      open_arguments[:projectFileName] = @tsconfig_path if @tsconfig_path
      send_command('open', open_arguments)
      seq = send_command('semanticDiagnosticsSync', file: @dummy_file_path)
      read_response(seq)
    end

    private

    def send_command(command, arguments)
      this_seq = @seq

      payload = {
        seq: this_seq,
        type: 'request',
        command: command,
        arguments: arguments
      }.to_json

      @tsserver_in.write(payload)
      @tsserver_in.write("\n")
      @seq += 1 # increment for the next request

      this_seq
    end

    def read_response(seq)
      content_length_line = @tsserver_out.readline
      unless content_length_line.start_with? 'Content-Length:'
        raise TSCheck::Error, "tsserver: unexpected response, wanted content-length, got: #{content_length_line}"
      end

      @tsserver_out.readline
      response_line = @tsserver_out.readline

      response = JSON.parse(response_line, symbolize_names: true)

      unless response[:request_seq] == seq
        return read_response(seq) # discard and read next response
      end

      unless response[:success]
        raise TSCheck::Error, "tsserver: error: #{response[:message]}"
      end


      response[:body].empty? ? nil : response[:body].map { |report| report[:text] }.join("\n")
    end
  end
end
