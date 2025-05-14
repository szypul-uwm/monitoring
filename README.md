# Monitoring serwera (CPU, GPU, RAM, HDD) przez Prometheus + Docker Compose

Ten projekt służy do monitorowania zasobów systemowych (CPU, GPU, RAM, HDD) na serwerze typu peer, a dane zbierane są centralnie przez Prometheusa.

## 🔍 Co jest monitorowane

| Zasób | Jak zbieramy dane | Źródło metryk |
|-------|-------------------|----------------|
| CPU   | zużycie, temperatura, rdzenie | `node_exporter` + `textfile_collector` |
| GPU   | zużycie, temperatura, wentylator | `dcgm_exporter` (NVIDIA) |
| RAM   | całkowite i dostępne | `node_exporter` |
| HDD   | partycje, zużycie dysku | `node_exporter` |

---

## 🔗 Dostęp do metryk (lokalnie na peerze)

| Eksporter          | Adres URL lokalny                   | Opis                          |
|--------------------|--------------------------------------|-------------------------------|
| Node Exporter      | `http://localhost:9100/metrics`      | RAM, CPU, HDD                 |
| GPU Exporter       | `http://localhost:9400/metrics`      | dane z kart NVIDIA           |
| Czujniki sprzętowe | `http://localhost:9100/metrics`      | temperatura i fan przez `.prom` |

---

## 📦 Wymagane pakiety na peerze

### Systemowe:
```bash
sudo apt update
sudo apt install lm-sensors docker.io docker-compose -y
sudo sensors-detect
