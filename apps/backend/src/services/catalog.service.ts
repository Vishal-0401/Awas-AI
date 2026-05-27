import { catalogRepository } from '../repositories/store';

class CatalogService {
  listCategories() {
    return catalogRepository.listCategories();
  }

  listServices(categoryId?: string, q?: string) {
    return catalogRepository.listServices(categoryId, q);
  }
}

export const catalogService = new CatalogService();
