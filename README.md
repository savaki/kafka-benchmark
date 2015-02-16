# kafka-benchmark

Kafka performance testing automated through terraform

## Prerequisites

* rake
	* only needed for the Rakefile, any version should do
* aws credentials
	* ensure ```AWS_ACCESS_KEY_ID``` and ```AWS_SECRET_ACCESS_KEY``` have been set
* terraform 0.3.6
	* ensure terraform is in your path


## Usage

### 1. edit settings.yml

Adjust these to fit your target environment:

```
aws:
  region: us-east-1
  availability_zone: us-east-1e
```

### 2. run the benchmark

```
rake aws:run_benchmark
```

# WORK IN PROGRESS - NOT READY FOR PRIME TIME YET

