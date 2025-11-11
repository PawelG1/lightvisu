import 'package:get_it/get_it.dart';
import 'package:deckmate/core/config/app_config.dart';
import 'package:deckmate/data/repositories/quiz_repository_impl.dart';
import 'package:deckmate/data/repositories/visualization_repository_impl.dart';
import 'package:deckmate/domain/usecases/initialize_quiz_usecase.dart';
import 'package:deckmate/domain/usecases/initialize_visualization_usecase.dart';
import 'package:deckmate/presentation/cubit/quiz/quiz_cubit.dart';
import 'package:deckmate/presentation/cubit/visualization/visualization_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Config
  getIt.registerSingleton<AppConfig>(AppConfig());

  // Repositories
  getIt.registerSingleton<VisualizationRepositoryImpl>(
    VisualizationRepositoryImpl(),
  );
  
  getIt.registerSingleton<QuizRepositoryImpl>(
    QuizRepositoryImpl(),
  );

  // Usecases
  getIt.registerSingleton<InitializeVisualizationUsecase>(
    InitializeVisualizationUsecase(
      repository: getIt<VisualizationRepositoryImpl>(),
    ),
  );

  getIt.registerSingleton<InitializeQuizUsecase>(
    InitializeQuizUsecase(
      repository: getIt<QuizRepositoryImpl>(),
    ),
  );

  // Cubits
  getIt.registerSingleton<VisualizationCubit>(
    VisualizationCubit(
      initializeUsecase: getIt<InitializeVisualizationUsecase>(),
      repository: getIt<VisualizationRepositoryImpl>(),
    ),
  );

  getIt.registerSingleton<QuizCubit>(
    QuizCubit(
      initializeUsecase: getIt<InitializeQuizUsecase>(),
      repository: getIt<QuizRepositoryImpl>(),
    ),
  );
}
