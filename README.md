# PartyPlanner

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)

Um aplicativo mobile (Flutter) para ajudar anfitriões a organizar eventos e gerenciar convidados e itens de forma eficiente.

## Funcionalidades

Este aplicativo MVP (Produto Mínimo Viável) inclui as seguintes funcionalidades:

* **Autenticação de Usuários (Simulada):**
    * Telas de Login e Registro de usuários.
    * Funcionalidade de Logout para o anfitrião.
* **Gestão de Eventos (Visão do Anfitrião):**
    * Dashboard com listagem de eventos.
    * Criação de novos eventos com:
        * Título, local, data, hora, descrição.
        * **Opções de Contribuição de Itens:** Anfitrião faz lista, não precisa levar nada, ou convidado escolhe.
        * **Controle de Acompanhantes (+1):** Permite ou não que convidados levem pessoas extras.
    * **Tela de Detalhes do Evento:**
        * Visualização detalhada do evento e suas configurações.
        * **Gestão de Convidados:** Adicionar, marcar presença (RSVP), ajustar número de acompanhantes e **remover convidados**.
        * **Gestão de Itens:** Registrar itens que convidados se comprometeram a trazer e **remover itens**.
        * **Análises de Estimativa:** Calculadoras de quantidade de bebida e carne com status de suficiência (baseado nos convidados confirmados).
        * **Geração e Cópia de Link de Convite (Simulado):** Para compartilhar o evento com convidados.
* **Experiência do Convidado:**
    * Tela de convite acessível via link (Deep Linking).
    * Confirmação de presença (RSVP).
    * Ajuste de acompanhantes (se permitido pelo anfitrião).
    * Interação com opções de contribuição de itens (selecionar da lista pré-definida ou sugerir item próprio).
* **Alertas e Lembretes (Simulados):**
    * Lógica para agendar lembretes para eventos (mensagens no console para esta versão).

## Como Rodar o Projeto

Este projeto Flutter foi desenvolvido para rodar primariamente como uma aplicação web em um ambiente de desenvolvimento em nuvem (como Google Cloud Shell).

### Pré-requisitos

* **Flutter SDK:** Instalado e configurado no seu ambiente (versão beta 3.32.0-0.2.pre ou compatível).
* **VS Code:** Com as extensões Dart e Flutter.
* **Git:** Instalado e configurado no seu PATH.
* **Conexão à Internet:** Para baixar dependências e acessar o Firebase (se for configurado no futuro).

### Configuração e Execução

1.  **Clone o Repositório:** (Se você estiver em um repositório Git)
    ```bash
    git clone [URL_DO_SEU_REPOSITORIO]
    cd party_planner
    ```
    (Se você está seguindo o tutorial e criando o projeto, você já está na pasta `party_planner`.)

2.  **Instale as Dependências:**
    Navegue até a raiz do projeto no terminal (`party_planner/`) e execute:
    ```bash
    flutter pub get
    ```

3.  **Configure o Firebase (Opcional - Se você quiser usar um backend real):**
    * Crie um projeto no [Console do Firebase](https://console.firebase.google.com/).
    * No terminal, execute:
        ```bash
        dart pub global activate flutterfire_cli
        flutterfire configure
        ```
        Siga as instruções para selecionar seu projeto e plataformas (Android/iOS se for compilar nativo, ou apenas ignore se o foco for web e simulações).
    * **Importante:** Adicione as dependências do Firebase ao `pubspec.yaml` (se ainda não estiverem lá, com as versões compatíveis). Exemplo:
        ```yaml
        dependencies:
          flutter:
            sdk: flutter
          firebase_core: ^2.32.0
          firebase_auth: ^4.20.0
          cloud_firestore: ^4.19.0
        ```
        E rode `flutter pub get` novamente.

4.  **Execute o Aplicativo na Web:**
    Para rodar o aplicativo em um navegador web (ideal para ambientes de nuvem como o Cloud Shell), no terminal na pasta raiz do projeto, execute:
    ```bash
    flutter run -d web-server --web-hostname 0.0.0.0 --web-port 9002
    ```
    * Você pode alterar a porta (`9002`) se ela estiver em uso.
    * **Para acessar o aplicativo:** No seu ambiente de nuvem (ex: Google Cloud Shell), use o recurso de **"Web Preview"** e selecione a porta que você está usando (ex: `9002`). Isso abrirá o aplicativo em uma nova aba do seu navegador local.

5.  **Testando o Link de Convite (Deep Link):**
    Após o aplicativo estar rodando e visível no seu navegador:
    * Faça login como anfitrião (login simulado: qualquer email/senha).
    * Vá para os detalhes de um evento e clique em "Gerar e Copiar Link de Convite".
    * O link será copiado para a área de transferência. Ele terá o formato `http://localhost:9002/#/invite/[ID_DO_EVENTO]`.
    * **Substitua `localhost:9002` pela URL real da sua "Web Preview"** (ex: `https://sua-instancia-abc.cloudshell.google.com:9002`).
    * Cole a URL ajustada na barra de endereços do seu navegador para testar o roteamento direto para a tela de convite.

## Estrutura do Projeto

A pasta `lib/` contém a maior parte do código do aplicativo, organizada da seguinte forma:

```
lib/
├── main.dart             # Ponto de entrada do aplicativo e roteamento principal
├── models/               # Definições de modelos de dados (Event, Guest, Item, etc.)
├── screens/              # Telas da interface do usuário (Login, Dashboard, Detalhes Evento, etc.)
├── services/             # Lógica de negócio e comunicação com backend/dados simulados (AuthService, EventService, CalculatorService, NotificationService)
├── utils/                # Funções utilitárias e ferramentas auxiliares (se houver)
└── widgets/              # Componentes de interface de usuário reutilizáveis
```