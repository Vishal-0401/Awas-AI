export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
}

export const paginate = async <T>(
  model: any,
  page: number = 1,
  limit: number = 10,
  where?: any
): Promise<PaginatedResult<T>> => {
  const skip = (page - 1) * limit;
  const [data, total] = await Promise.all([
    model.findMany({ skip, take: limit, where }),
    model.count({ where }),
  ]);

  return {
    data,
    pagination: {
      page,
      limit,
      total,
      pages: Math.ceil(total / limit),
    },
  };
};