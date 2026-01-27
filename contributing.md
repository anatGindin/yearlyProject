# Contributing to Hamal Transportation App

## Branching Strategy

We follow a sprint-based branching model:

| Branch | Purpose | Protected |
|--------|---------|-----------|
| `main` | Production-ready code. Contains stable releases after sprint completion. | ✅ |
| `dev/vX.X.X` | Active sprint development branch. All feature work is merged here during the sprint. | ✅ |
| `feature/*` | Individual feature branches (e.g., `feature/add-login-screen`) | ❌ |
| `fix/*` | Bug fix branches (e.g., `fix/navigation-crash`) | ❌ |

## Workflow

### During a Sprint
1. Create a feature branch from the current sprint branch (`dev/vX.X.X`)
   ```bash
   git checkout dev/v0.0.4
   git pull
   git checkout -b feature/your-feature-name
   ```
2. Make your changes and commit
3. Push your branch and open a Pull Request targeting `dev/vX.X.X`
4. After code review and approval, merge into `dev/vX.X.X`

### End of Sprint
- Once the sprint is complete and tested, `dev/vX.X.X` is merged into `main`
- New Release published with release notes, based on a new tag created on the new merged commit into the main branch
- APK of the new version is uploaded to our [landing page](https://idotalk.github.io/Hamal-landing-page/)
- A new sprint branch `dev/vX.X.Y` is created for the next sprint

## Branch Naming Conventions

- Features: `feature/short-description`
- Bug fixes: `fix/short-description`
- Sprint development: `dev/vX.X.X`
- Example: `feature/driver-location-tracking`, `fix/login-timeout`, `dev/v0.0.4`

## Pull Request Guidelines

1. Give your PR a clear, descriptive title
2. Reference related issues (e.g., "Closes #123")
3. Request review from at least one team member
4. **At least one approval is required before merging any PR**
5. **No PR may be merged unless all CI checks have passed**
6. Please delete your work branch after merging

## Issues & Backlog Handling

### Creating Issues

- When creating a new issue, always assign appropriate labels (e.g., `bug`, `feature`, `documentation`, `help wanted`)
- Establish relationships by linking related issues (use “parent”, “depends on” or “blocks”)

### Backlog Workflow

- **All new tasks** begin in the **Backlog** list; some may be marked as “blocked” if waiting for dependencies.
- The **Ready** list includes issues planned for the current sprint and are not blocked.  
  Issues are moved to this list and assigned to team members during our weekly meeting.
- Issues are moved to **In Progress** as soon as implementation begins.
- When implementation is finished:
  1. Open a Pull Request and link it to the relevant issue
  2. Move the issue to the **In Review** list  
- After approval and PR merging, move the issue to the **Done** list.
  _Note: Issues labeled as **Epic** or **Story** remain in their dedicated lists throughout the process to maintain a clear issue hierarchy._

#### Example Issue Flow

> Backlog → Ready → In Progress → In Review → Done

This workflow helps us keep track of tasks, dependencies, and current development status throughout the sprint.

