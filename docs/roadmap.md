### 路线图

[English Version](./roadmap_en.md)

##### 资产管理
  - [x] 模型管理：支持git协议和Web网页，支持分支版本化管理，支持权限控制
  - [x] 数据集管理：支持git协议和Web网页，支持分支版本化管理，支持权限控制
  - [x] 大文件支持：支持git lfs协议和oss存储
  - [ ] 内置代码仓库：内置代码Repo管理功能，可关联模型、数据集、Space空间应用的代码。
  - [ ] 多源数据同步: 支持配置并启用远端仓库, 自动数据同步，支持OpenCSG传神社区、Huggingface等远端源。
  - [ ] 在线编辑: 模型/数据集/代码Repo支持通过Web界面上传、下载、编辑或删除文件，支持提交变更commit。
  - [ ] 数据集查看: 数据集Web查看工具，支持多种格式数据集的元数据和TopN数据查看。
##### AI能力增强
  - [x] 数据集预览：支持数据集数据预览功能
  - [ ] 一键微调: 支持与OpenCSG llm-finetune集成，一键启动模型微调训练。
  - [ ] 一键推理: 支持与OpenCSG llm-inference集成，一键启动模型推理服务。
  - [ ] 数据格式转化: 主流模型和数据集格式转换，支持配置自动化格式转换规则。
  - [ ] 资产Copilot: 实现资产管理Copilot，支持以Chatbot或者API为接口自然语言查询和管理资产。
##### 应用与企业功能
  - [x] 权限控制：支持私有项目和公开项目权限设置，支持组织机构和个人账号
  - [ ] 应用空间: 支持托管Gradio/Streamlit应用并发布到Space应用空间
  - [ ] 细粒度权限控制：面向企业架构的细粒度权限和访问控制设置
##### 安全合规
  - [x] Git适配：支持Gitea Server
  - [x] 安全设计：接口鉴权机制、支持私有化部署
  - [ ] GitServer适配器: 通用GitServer适配器，通过Adaptor模式实现对多种主流Git仓库后端的支持。
  - [ ] 资产元数据: 资产元数据管理机制， 支持自定义元数据类型和对应的AutoTag规则。
  - [ ] 合规性验证: 模型和License合规性溯源与验证
  - [ ] 完整性校验：数据的完整性校验机制
