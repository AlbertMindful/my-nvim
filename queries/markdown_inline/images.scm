; extends

; Markdown 自己识别公式，无需安装会与 vimtex 冲突的 LaTeX 解析器。
((latex_block) @image.content @image
  (#set! image.ext "math.tex")
  (#set! image.lang "latex"))
