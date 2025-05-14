from jinja2 import Environment, FileSystemLoader
from pathlib import Path
import argparse

def gen_gemm(I, K, J):
    script_dir = Path(__file__).resolve().parent
    template_dir = script_dir
    environment = Environment(loader=FileSystemLoader(template_dir))
    file_name = Path(f"template_gemm.py")
    template = environment.get_template(str(file_name))
    file_dst = Path(f"gemm_{I}x{K}x{J}.py")
    dstName = script_dir  / file_dst
    content = template.render(
        I = I,
        K = K,
        J = J,
    )
    with open(dstName, mode="w", encoding="utf-8") as message:
        message.write(content)
        print(f"... wrote {dstName}")

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('--I', type=int, required=True)
  parser.add_argument('--K', type=int, required=True)
  parser.add_argument('--J', type=int, required=True)
  args = parser.parse_args()
  gen_gemm(args.I, args.K, args.J)