# sign-oot-kmods 

Tekton task that signs out-of-tree kernel modules.

The path to the directory inside the provided workspace where the binaries were
saved is provided as a result.

The binaries must be stored at the same `image_binaries_path` for each component
passed.

## Parameters

| Name                | Description                                                                | Optional | Default value         |
|---------------------|----------------------------------------------------------------------------|----------|-----------------------|
| dataPath            | Path to the data JSON in the data workspace                                | No       | -                     |
| signedKmodsPath     | Path where the kernel modules are stored in the workspace                  | No       | -                     |
| signingAuthor       | Human name responsible for the signing process                             | No       | -                     |
| checkSumFingerprint | Secret containing the host key database for SSH the server running signing | No       | -                     |
| checkSumKeytab      | Secret containing keytab file for the Kerberos user / server               | No       | -                     |
| signing-secret      | Secret containing the fields signHost, SignKey and SignUser                | No       | -                     |
| kerberosRealm       | Kerberos realm for the checksum host                                       | No       | -                     |
