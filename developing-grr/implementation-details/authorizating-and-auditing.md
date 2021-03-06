# Authorization and Auditing

GRR contains an audit framework that logs all requests coming through the GRR
API (the admin UI also uses said API as the backend so all requests through the
UI are logged too). The username that is logged is generated by the chosen
WebAuthManager (in practice often the BasicWebAuthManager which uses basic http
authentication).

## Reading the Audit Log

The audit log is currently not surfaced in any UI. The following code snippet
illustrated hot to read the audit log through the GRR console:

```python
end_time = rdfvalue.RDFDatetime.Now()
start_time = end_time - rdfvalue.Duration("52w")

result = data_store.REL_DB.ReadAPIAuditEntries(min_timestamp=start_time,
                                               max_timestamp=end_time)

print result[0]

message APIAuditEntry {
 http_request_path : u'/api/clients/C.071d6e8cc079bf11/flows/33D85D32?'
 response_code : OK
 router_method_name : u'GetFlow'
 timestamp : RDFDatetime:
    2019-05-13 14:54:19
 username : u'amoser'
}

```
