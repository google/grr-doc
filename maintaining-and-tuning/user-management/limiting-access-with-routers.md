# Limiting access to GRR UI/API with API routers

GRR has a notion of *API call routers*. Every API request that GRR server handles is processed in a following fashion:

1. A username of a user making the request is matched against rules in the router configuration file (as defined in the `API.RouterACLConfigFile` config option).
    - If router configuration file is not set, a default router is used. Default router is specified in the `API.DefaultRouter` configuration option.
    - If one of the rules in the `API.RouterACLConfigFile` matches, then a router from the matching rule is used.
2. The API router is used to process the request.

GRR has a few predefined API routers:

- *DisabledApiCallRouter* - a router that will return an error for all possible requests.
- *ApiCallRouterWithoutChecks* *(default)* - a router that performs no access checks and just gives blanket access to the system.
- *ApiCallRouterWithApprovalChecks* - a router that enables GRR approvals-based workflow for better auditing. See [Approval-based workflow](../approval-based-workflow.md) for more details.
- *ApiCallRobotRouter* - a router that provides limited access to the system that is suitable for automation. Normally used together with *ApiCallRouterWithApprovalChecks* so that scripts and robots can perform actions without getting approvals.

## Various configuration scenarios

### All GRR users should have unrestricted access *(default)*

In GRR server configuration file:

``` yaml
API.DefaultRouter: ApiCallRouterWithoutChecks
```

### All GRR users should follow audit-based workflow

In GRR server configuration file:

``` yaml
API.DefaultRouter: ApiCallRouterWithApprovalChecks
```

### GRR users should follow audit-based workflow, but user "john" should have blanket access.

In GRR server configuration file:

``` yaml
API.RouterACLConfigFile: /etc/grr_api_acls.yaml
API.DefaultRouter: ApiCallRouterWithApprovalChecks
```

In `/etc/grr_api_acls.yaml`:

``` yaml
router: "ApiCallRouterWithoutChecks"
users:
  - "john"
```

**NOTE**: for example, you can set up user 'john' as a robot user, so that his credentials are used by scripts talking to the GRR API.


Sample api_acls.yaml:

```
router: "ApiCallRobotRouter"
users:
   - "serviceAccount1"

router: "ApiCallRouterWithApprovalChecks"
users:
  - "test"
  - "test2"

router: "ApiCallRouterWithoutChecks"
users:
  - "adminuser1"
  - "adminuser2"

```
