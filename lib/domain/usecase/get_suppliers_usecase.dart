
import 'package:supplierconnectapp/data/models/supplier_models.dart';
import 'package:supplierconnectapp/data/repository/auth_repository.dart';

class GetSuppliersUseCase {
  final AuthRepository repository;

  GetSuppliersUseCase(this.repository);

  Future<List<SupplierModel>> execute() async {
    return await repository.getSuppliers();
  }
}