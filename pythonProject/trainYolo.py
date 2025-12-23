from ultralytics import YOLO
import torch
torch.mps.empty_cache()
# Load a model
model = YOLO("yolo11n.pt")  # load a pretrained model (recommended for training)

results = model.train(data="/Users/yataseve/PycharmProjects/pythonProject/datasets/person-weapon datasets/data.yaml", epochs=100, imgsz=640, batch=-1, device="mps")
