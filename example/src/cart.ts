export type Cart = {
  items: {
    name: string;
    price: number;
    discount?: number;
  }[];
  total: number;
};
