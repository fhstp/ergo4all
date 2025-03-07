# ergo4all

<table style="border-collapse: collapse; border: none">
    <tr>
        <th style="border: none">Powered by</th>
        <th style="border: none">Project partners</th>
    </tr>
    <tr>
        <th style="border: none">
            <img src="apps/ergo4all/assets/images/logos/ak.jpg" height="150px" />
        </th>
        <th style="border: none">
            <img src="apps/ergo4all//assets/images/logos/tuwien.jpg" height="150px" />
            <img src="apps/ergo4all//assets/images/logos/fhstp.png" height="150px" />
        </th>
    </tr>
</table>

The main repository for the [Ergo4All](https://research.fhstp.ac.at/projekte/ergo4all-ergonomie-fuer-alle) project.

Checkout the projects [Changelog](./CHANGELOG.md) to see what's new.

## Project structure

This is a monorepo/workspace project with the following parts.

| Name                                                        | Description                                      |
| ----------------------------------------------------------- | ------------------------------------------------ |
| [ergo4all](./apps/ergo4all/README.md)                       | The main Ergo4All app                            |
| [pose_tester](./apps/pose_tester/README.md)                 | A testing app for pose detection and scoring     |
| [common](./packages/common/README.md)                       | Common dart logic                                |
| [common_ui](./packages/common_ui/README.md)                 | Common ui logic                                  |
| [custom_locale](./packages/custom_locale/README.md)         | Logic for managing a custom locale setting       |
| [pose](./packages/pose/README.md)                           | Common pose types and logic                      |
| [pose_analysis](./packages/pose_analysis/README.md)         | Logic for analyzing and scoring poses            |
| [pose_detect](./packages/pose_detect/README.md)             | Logic to extract poses from images               |
| [pose_transforming](./packages/pose_transforming/README.md) | Logic for transforming and normalizing pose data |
| [pose_vis](./packages/pose_vis/README.md)                   | UI logic for visualizing poses                   |
| [rula](./packages/rula/README.md)                           | Logic modelling the RULA sheet                   |
| [user_management](./packages/user_management/README.md)     | User management logic                            |

## Develop

To get started developing, [install Flutter](https://docs.flutter.dev/get-started/install), preferably using [fvm](https://fvm.app/). Then clone the repo and run `fvm use` inside the project directory to setup the correct flutter sdk.

It is recommended to use VSCode with the [recommended extensions](./.vscode/extensions.json).
