from jinja2 import Environment, FileSystemLoader
from pathlib import Path
import re

def gen_make_aries(prj_dir, template_dir, subName, func, paraSize, l2Size, placement, placeAlgo, linkFile, aieUnroll, bufSel):
    environment = Environment(loader=FileSystemLoader(template_dir))
    file_name = 'Makefile_ARIES'
    template = environment.get_template(file_name)
    file_dst = "Makefile"
    filename = prj_dir / file_dst
    
    dim = len(paraSize)
    numBuf = len(bufSel)
    content = template.render(
        func = func,
        subName = subName,
        parallel = paraSize,
        l2buffer = l2Size,
        dim = dim,
        placement = placement,
        placeAlgo = placeAlgo,
        linkFile = linkFile,
        aieUnroll = aieUnroll,
        numBuf = numBuf,
        bufSel = bufSel,
        template_dir = template_dir
    )
    with open(filename, mode="w", encoding="utf-8") as message:
        message.write(content)
        print(f"... wrote {filename}")

def gen_kernel(sub_dir, template_dir, kernel_dir, paraList, func_name=""):
    template_dir = Path(template_dir)
    kernel_dir = Path(kernel_dir)
    file_dir = template_dir / kernel_dir
    environment = Environment(loader=FileSystemLoader(file_dir))
    
    pattern = re.compile(r"^([a-zA-Z_]+)(\d*)\.cc$")
    root_name = ""
    numbers = []
    for file_path  in file_dir.rglob("*.cc"):
        file_name = file_path.name
        match = pattern.match(file_name)
        if match:
            root_name = match.group(1)
            number = match.group(2)
            if number != "":
                numbers.append(int(number))
    numbers.sort()
    
    temp_list = [root_name] + [f"{root_name}{num}" for num in numbers]
    dst_list = [func_name] + [f"{func_name}{num}" for num in numbers]
    
    for i, tempName in enumerate(temp_list):
      template = environment.get_template(tempName + ".cc")
      dst_name = dst_list[i]
      file_dst = "aie/" + dst_name + ".cc"
      filename = sub_dir / file_dst
      content = template.render(
          dst_name = dst_name,
          paraList = paraList
      )
      with open(filename, mode="w", encoding="utf-8") as message:
          message.write(content)
          print(f"... wrote {filename}")
    
    return