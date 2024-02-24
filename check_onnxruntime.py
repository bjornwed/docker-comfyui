from optimum.onnxruntime import ORTModelForSequenceClassification
from transformers import AutoTokenizer

ort_model = ORTModelForSequenceClassification.from_pretrained(
  "philschmid/tiny-bert-sst2-distilled",
  export=True,
  provider="CUDAExecutionProvider",
)

tokenizer = AutoTokenizer.from_pretrained("philschmid/tiny-bert-sst2-distilled")
inputs = tokenizer("expectations were low, actual enjoyment was high", return_tensors="pt", padding=True)

outputs = ort_model(**inputs)
assert ort_model.providers == ["CUDAExecutionProvider", "CPUExecutionProvider"]