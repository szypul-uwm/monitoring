# Monitoring serwera (CPU, GPU, RAM, HDD) przez Prometheus + Docker Compose

Ten projekt służy do monitorowania zasobów systemowych (CPU, GPU, RAM, HDD) na serwerze typu peer, a dane zbierane są centralnie przez Prometheusa.

## 🔍 Co jest monitorowane

| Zasób | Jak zbieramy dane                | Źródło metryk                          |
| ----- | -------------------------------- | -------------------------------------- |
| CPU   | zużycie, temperatura, rdzenie    | `node_exporter` + `textfile_collector` |
| GPU   | zużycie, temperatura, wentylator | `dcgm_exporter` (NVIDIA)               |
| RAM   | całkowite i dostępne             | `node_exporter`                        |
| HDD   | partycje, zużycie dysku          | `node_exporter`                        |

---

## 🔗 Dostęp do metryk (lokalnie na peerze)

| Eksporter          | Adres URL lokalny               | Opis                            |
| ------------------ | ------------------------------- | ------------------------------- |
| Node Exporter      | `http://localhost:9100/metrics` | RAM, CPU, HDD                   |
| GPU Exporter       | `http://localhost:9400/metrics` | dane z kart NVIDIA              |
| Czujniki sprzętowe | `http://localhost:9100/metrics` | temperatura i fan przez `.prom` |

---

## 📦 Wymagane pakiety na peerze

### Systemowe:

```bash
sudo apt update
sudo apt install lm-sensors docker.io docker-compose -y
sudo sensors-detect
```

Podczas `sensors-detect`, wybierz `yes`, aby dodać moduły np. `coretemp`, `nct6775` do `/etc/modules`.

### NVIDIA (jeśli masz GPU):

```bash
sudo apt install nvidia-driver-525
sudo apt install nvidia-container-toolkit
sudo systemctl restart docker
```

---

## 🚀 Uruchomienie eksportera w Docker Compose

1. Sklonuj repozytorium lub utwórz katalog:

```bash
mkdir ~/monitoring && cd ~/monitoring
```

2. Stwórz plik `docker-compose.yml` z odpowiednią zawartością.

3. Uruchom eksportery:

```bash
docker compose up -d
```

---

## 🛠️ Skrypt do czujników sprzętowych (`sensors.prom`)

Nadaj prawa:

```bash
chmod +x ./scripts/metrics.sh
```

Dodaj do `crontab`, aby uruchamiać co 1 minutę:

```bash
crontab -e
```

Wklej na końcu:

```cron
* * * * * ~/monitoring/scripts/metrics.sh
```

📌 Skrypt działa w interwale 1 minuty, a dane czujników odświeżane są co 14 sekund w ramach 4 kolejnych odczytów.

---
