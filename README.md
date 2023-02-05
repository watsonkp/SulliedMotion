# SulliedMotion

This package provides functionality to record, analyze, view, and store motion data emitted by the [CoreMotion](https://developer.apple.com/documentation/coremotion/) framework. It is currently a work in progress with bare minimum functionality for experimentation.

The current functionality is sufficient to receive emitted [Device Motion](https://developer.apple.com/documentation/coremotion/cmdevicemotion) data, compute a few simple statistics, and save it to a [JSON](https://www.json.org/json-en.html) file.

Work is being done to develop statistical processes capable of detecting and counting repeated motions. Experiments are being conducted on exported JSON motion data using the [NumPy](https://numpy.org/), [SciPy](https://scipy.org/) and [Matplotlib](https://matplotlib.org/) [Python](https://www.python.org/) libraries.
