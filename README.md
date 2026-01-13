# Pokédex

Desafio proposto pela empresa Serasa Experian.

## Objetivo

- Criar uma aplicação que liste Pokemons e permita visualizar detalhes de um Pokemon.
- Desafio: 
    - Implementar Clean Architecture
    - Segregar lógica da UI
    - Testes unitários de camadas
    - (Opcional): Adicionar Analytics com method channels pra emitir eventos


- Material de apoio:
    - Figma: https://www.figma.com/design/pRGRELlzALdMtPxsEimU9B/Pokedex?node-id=0-1&p=f&t=7WypctaRyRKbBbOe-0
    - API: https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json
    - Analytics iOS: https://firebase.google.com/docs/analytics/get-started?platform=ios&hl=pt-br
    - Analytics Android: https://firebase.google.com/docs/analytics/get-started?platform=android&hl=pt-br

## Escolhas
- Cubit: é um gestor de estado simples e direto ao ponto, somado a clean, pode parecer muito complexo, mas é uma escolha que me permite somar uma preferência pessoal com o desafio proposto que foi o Clean Architecture. 

- Equatable: Ajuda muito em testes e comparativos de objetos

- Dio: Simples e prático, permite uso fácil de interceptors, timeout e outras configurações.

- GetIt: Amplamente usado no mercado, principalmente com um state management que não cuida de injeções, como o Riverpod por exemplo. Permite registrar dependdências de forma gradual usando lazy load.

- Either (dartz): Two lefts don't make a right. 

- Storybook: Permite visualizar componentes de forma isolada e interativa.

- Mocktail: Permite mockar funções de forma simples e direta.


## Versões
[✓] Flutter (Channel stable, 3.32.8, on macOS 15.6.1 24G90 darwin-arm64, locale en-BR)

[√] Android toolchain - develop for Android devices (Android SDK version 35.0.0)

[✓] Xcode - develop for iOS and macOS (Xcode 16.2)

[✓] Chrome - develop for the web

[✓] Android Studio (version 2024.1)

[✓] VS Code (version 1.106.3)


## Configuração pra executar
- Instalação do Flutter seguindo as instruções da doc oficial: 
  - https://docs.flutter.dev/get-started/install

- Configure o arquivo .env com as variáveis de ambiente
  - POKEDEX_URL=[URL da API]

## Executar
- Para executar o Storybook: flutter pub run storybook_flutter:main
- Para executar a aplicação: flutter run

Ou caso utilize VSCode, basta clicar no botão "Run" no editor, que já conta com ambas configurações.

