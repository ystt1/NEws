import 'package:bloc/bloc.dart';
import 'package:tbdd/blocs/brachesBLoC/branches_event.dart';
import 'package:tbdd/blocs/brachesBLoC/branches_state.dart';
import 'package:tbdd/repositories/BranchRepository.dart';

import '../../Models/Branch.dart';



class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchRepository _branchRepository=BranchRepository();
  List<Branch> branches=[];
  BranchesBloc() :super(BranchesInitial([])) {

    on<GetOtherBranchesEvent>((event, emit) async {
      branches=await _branchRepository.getBranches();
       final List<Branch> otherBranches = branches.where((branch) =>
      branch != event.selectedBranch).toList();
      return emit(BranchesLoaded(branches,otherBranches));
    });
  }
}