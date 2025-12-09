---
title: "firestone"
linkTitle: "firestone"
weight: 10
---

# firestone

### A Resource-Based Approach to Building APIs

`firestone` allows you to build OpenAPI, AsyncAPI and gRPC specs based off one or more resource JSON schema files. This allows you to focus on what really matters, the resource you are developing!

[Project Repository](https://github.com/firestoned/firestoned/tree/main/firestone)

Once you have generated the appropriate specification file for your project, you can then use the myriad of libraries and frameworks to generate stub code.

**The primary premise of this project is not to introduce any new "language" to describe your resource(s), rather, use JSON Schema!**

This makes it easy to come up to speed with little to no prior knowledge to get going.

## Quick Start

We recommend using `poetry` to install and run `firestone`.

### `poetry`

It's as simple as running the following command:

```zsh
poetry add firestoned
poetry build
```

## Running

Now that you have a copy of `firestone`, let's try running it with the example resource provided, an addressbook!

### Generate an OpenAPI Spec

```zsh
firestone \
    generate \
    --title 'Addressbook resource' \
    --description 'A simple addressBook example' \
    --resources examples/addressBook/resource.yaml \
    openapi
```

This will output the specification file to `stdout`. You can provide the `-O` option to output to a specific file.

You can also add the command line `--ui-server` to the end, which will launch a small webserver and run the Swagger UI to view this specification file.

```zsh
firestone generate ... openapi --ui-server
```

Now you can use your browser to navigate to `http://127.0.0.1:5000/apidocs` to view the Swagger UI.

## Schema

It all begins with your resource definition! This is done using JSON schema. Here is an example:

```yaml
# Metadata: start
name: addressbook
description: An example of an addressbook resource
version: 1.0
methods:
  resource:
    - get
    - post
  instance:
    - delete
    - get
    - put
# Metadata: end
schema:
  type: array
  key:
    name: address_key
    schema:
      type: string
  items:
    type: object
    properties:
      addrtype:
        description: The address type, e.g. work or home
        type: string
        enum:
          - work
          - home
      street:
        description: The street and civic number of this address
        type: string
      city:
        description: The city of this address
        type: string
      state:
        description: The state of this address
        type: string
      country:
        description: The country of this address
        type: string
    required:
      - addrtype
      - street
      - city
      - state
      - country
```

The schema is composed of a metadata section and a schema section. The metadata section contains information about the resource, such as its name, description, and the HTTP methods to expose. The schema section is a standard JSON schema that defines the resource's structure.

### Generate OpenAPI Client

Now, to generate your OpenAPI client, you will need the `openapi-generator` command. This client code can then be used as an SDK or used by our CLI generation, for example:

```zsh
openapi-generator generate \
    -i examples/addressbook/openapi.yaml \
    -g python-nextgen \
    -o /tmp/addressbook-client
```