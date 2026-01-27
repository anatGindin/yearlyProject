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
- A new sprint branch `dev/vX.X.Y` is created for the next sprint

## Branch Naming Conventions

- Features: `feature/short-description`
- Bug fixes: `fix/short-description`
- Example: `feature/driver-location-tracking`, `fix/login-timeout`

## Pull Request Guidelines

1. Give your PR a clear, descriptive title
2. Reference related issues (e.g., "Closes #123")
3. Request review from at least one team member
4. **At least one approval is required before merging any PR**
5. Ensure all CI checks pass before merging
6. Please delete your work branch after merging
