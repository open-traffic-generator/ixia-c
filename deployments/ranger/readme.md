# Ixia-C Docker Deployment over Ranger

---

## 📌 Overview

This guide provides step-by-step instructions to deploy **Ixia-C services** using Docker and configure **Ranger** on a KCOS host.


## ⚙️ Prerequisites

* Docker & Docker Compose installed
* Access to KCOS host
* Network connectivity between Docker host and KCOS

---

## 🚀 1. Deploy Core Services [keng-controller, otg-gnmi-server, keng-layer23-hw-server]

### ▶️ Start Services

```sh
docker compose -f deployments/ranger/topology.yml up -d
```

### 🛑 Stop Services

```sh
docker compose -f deployments/ranger/topology.yml down
```

### ⚠️ Important Note

- To enable **L23 (Rustic) mode**, add the following flag in `keng-layer23-hw-server`:

    ```yaml
    command:
        - "--enable-fast-path"
    ```

- Add license servers while deploying `keng-controller` using the `LICENSE_SERVERS` environment variable.
    #### Example
    ```yaml
    environment:
        - LICENSE_SERVERS=<license-server-ip-or-hostname>
    ```

---

## 🖥️ 2. Ranger Deployment on KCOS

### 🔍 Check Installed Version

```sh
kcos system welcome-screen show
```

### 📦 List Available Releases

```sh
kcos deployment available-updates
```

### ⬆️ Install / Upgrade Ranger

```sh
kcos deployment online-install kcos-sert-100ge/<version>
```

---

## 🔧 3. Configure Ranger Modes

### Available Modes

* **NGPF / IxNetwork**
* **L23 / Rustic** (Disabled by default)

---

### 🔎 Check Fast Path Status

```sh
kcos system introspection apps-l23 status-fast-path
```

### ✅ Enable L23 Mode

```sh
kcos system introspection apps-l23 enable-fast-path
kcos system reboot
```

### ❌ Disable L23 Mode

```sh
kcos system introspection apps-l23 disable-fast-path
kcos system reboot
```

## 🌐 OTG Port Configuration
During test execution, the **OTG port location must follow this format**:

```json
    <ranger-hostname>/<port-id>
```

### Example
```json
    ranger-rev2-5.lbj.is.keysight.com/5
```

### Ensure
- Hostname is reachable from the Docker environment  
- Port ID corresponds to the correct hardware port 