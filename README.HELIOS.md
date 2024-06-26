# Helios

# Using the `.helios` Format for `dotenv` Projects

This guide provides instructions on setting up and utilizing the `.helios` file format to manage your `dotenv` cloud projects efficiently. It specifically addresses the `dotenv` section and its `project` property, which are custom to the `.helios` configuration for your app.

## Structure of the `.helios` File

The `.helios` file format offers a structured approach to managing environment settings, making it especially useful for Infrastructure as Code (IaC) projects that require organized and manageable configurations.

### Example of a Basic `.helios` File

Below is an example of a simple `.helios` file structure:

```ini {"id":"01J0AGZT1Z97ZZZMYBCF4Q03KR"}
[dotenv]
project=my-dot-env-project-name
```

- references
  - https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
  - https://tools.ietf.org/html/rfc1123
  - https://tools.ietf.org/html/rfc1035
