
//===----------------------------------------------------------------------===//
//
// Automatically generated file for hlc.cpp
//
//===----------------------------------------------------------------------===//
#include <math.h>
#include <stdint.h>
#include <ap_int.h>
#include <ap_fixed.h>
#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include <hls_math.h>
void send3_0(
  hls::stream< ap_int<128> > &v50 /* v50[1] */,
  ap_int<128> v51[4][16][8],
  bool v52
){
  #pragma HLS inline OFF
  if (v52) {	// L188
    for (int v53 = 0; v53 < 2; v53++) {	// L189
      for (int v54 = 0; v54 < 2; v54++) {	// L190
        for (int v55 = 0; v55 < 2; v55++) {	// L191
          for (int v56 = 0; v56 < 8; v56++) {	// L192
            for (int v57 = 0; v57 < 2; v57++) {	// L193
              for (int v58 = 0; v58 < 4; v58++) {	// L194
              #pragma HLS pipeline II=1
                ap_int<128> v59 = v50.read(); //v50                v59 = v50;	// L195
                v51[(v55 + (v53 * 2))][(v56 + (v54 * 8))][(v58 + (v57 * 4))] = v59;	// L196
              }
            }
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v60[4][16][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v61 /* v61[1] */,
  bool v62
){
  #pragma HLS inline OFF
  if (v62) {	// L207
    for (int v63 = 0; v63 < 2; v63++) {	// L208
      for (int v64 = 0; v64 < 2; v64++) {	// L209
        for (int v65 = 0; v65 < 2; v65++) {	// L210
          for (int v66 = 0; v66 < 2; v66++) {	// L211
            for (int v67 = 0; v67 < 2; v67++) {	// L212
              for (int v68 = 0; v68 < 8; v68++) {	// L213
                for (int v69 = 0; v69 < 4; v69++) {	// L214
                #pragma HLS pipeline II=1
                  ap_int<128> v70 = v60[(v67 + (v63 * 2))][(v68 + (v65 * 8))][(v69 + (v66 * 4))];	// L215
                  ap_axiu<128, 0 ,0 ,0> v61_axiu;
                  v61_axiu.data = v70;
                  v61_axiu.keep = -1;
                  v61.write(v61_axiu); //v61                  v61 = v70;	// L216
                }
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send3(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v71 /* v71[1] */,
  hls::stream< ap_int<128> > &v72 /* v72[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v73[4][16][8];	// L233
  #pragma HLS bind_storage variable=v73 type=ram_t2p impl=uram
  ap_int<128> v74[4][16][8];	// L234
  #pragma HLS bind_storage variable=v74 type=ram_t2p impl=uram
  for (int v75 = 0; v75 < 1; v75++) {	// L235
    for (int v76 = 0; v76 < 2; v76++) {	// L236
      for (int v77 = 0; v77 < 2; v77++) {	// L237
        for (int v78 = 0; v78 < 2; v78++) {	// L238
          int v79 = v77 * 2;	// L239
          int v80 = v78 + v79;	// L240
          int v81 = v76 * 4;	// L241
          int v82 = v80 + v81;	// L242
          int v83 = v75 * 8;	// L243
          int v84 = v82 + v83;	// L244
          int v85 = v84 % 2;	// L245
          bool v86 = v85 == 0;	// L246
          bool v87 = v84 != 0;	// L247
          if (v86) {	// L248
            send3_0(v72, v73, 1);	// L249
            send3_1(v74, v71, v87);	// L250
          } else {
            send3_0(v72, v74, 1);	// L252
            send3_1(v73, v71, v87);	// L253
          }
        }
      }
    }
  }
  send3_1(v74, v71, 1);	// L259
}

void send3_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v88 /* v88[1] */,
  hls::stream< ap_int<128> > &v89 /* v89[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v90 /* v90[1] */,
  hls::stream< ap_int<128> > &v91 /* v91[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v92 /* v92[1] */,
  hls::stream< ap_int<128> > &v93 /* v93[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v94 /* v94[1] */,
  hls::stream< ap_int<128> > &v95 /* v95[1] */
){
  #pragma HLS inline OFF
  send3<0>(v88, v89);	// L263
  send3<1>(v90, v91);	// L264
  send3<2>(v92, v93);	// L265
  send3<3>(v94, v95);	// L266
}

template<int NC>
void load2(
  ap_int<512> v96[128][8],
  hls::stream< ap_int<512> > &v97 /* v97[1] */,
  hls::stream< ap_int<512> > &v98 /* v98[1] */,
  hls::stream< ap_int<512> > &v99 /* v99[1] */,
  hls::stream< ap_int<512> > &v100 /* v100[1] */
){
  #pragma HLS inline OFF
  for (int v101 = 0; v101 < 1; v101++) {	// L271
    for (int v102 = 0; v102 < 2; v102++) {	// L272
      for (int v103 = 0; v103 < 2; v103++) {	// L273
        for (int v104 = 0; v104 < 2; v104++) {	// L274
          for (int v105 = 0; v105 < 2; v105++) {	// L275
            for (int v106 = 0; v106 < 16; v106++) {	// L276
              for (int v107 = 0; v107 < 2; v107++) {	// L277
                for (int v108 = 0; v108 < 2; v108++) {	// L278
                #pragma HLS pipeline II=1
                  ap_int<512> v109 = v96[((v106 + (v105 * 32)) + (v104 * 64))][((v108 + (v107 * 2)) + (v102 * 4))];	// L279
                  bool v110 = v108 < 1;	// L280
                  if (v110) {	// L281
                    v99.write(v109); //v99                    v99 = v109;	// L282
                  } else {
                    v98.write(v109); //v98                    v98 = v109;	// L284
                  }
                }
              }
            }
          }
          for (int v111 = 0; v111 < 2; v111++) {	// L290
            for (int v112 = 0; v112 < 16; v112++) {	// L291
              for (int v113 = 0; v113 < 2; v113++) {	// L292
                for (int v114 = 0; v114 < 2; v114++) {	// L293
                #pragma HLS pipeline II=1
                  ap_int<512> v115 = v96[(((v112 + (v111 * 32)) + (v104 * 64)) + 16)][((v114 + (v113 * 2)) + (v102 * 4))];	// L294
                  bool v116 = v114 < 1;	// L295
                  if (v116) {	// L296
                    v97.write(v115); //v97                    v97 = v115;	// L297
                  } else {
                    v100.write(v115); //v100                    v100 = v115;	// L299
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load2_top(
  ap_int<512> v117[128][8],
  hls::stream< ap_int<512> > &v118 /* v118[1] */,
  hls::stream< ap_int<512> > &v119 /* v119[1] */,
  hls::stream< ap_int<512> > &v120 /* v120[1] */,
  hls::stream< ap_int<512> > &v121 /* v121[1] */
){
  #pragma HLS inline OFF
  load2<0>(v117, v118, v119, v120, v121);	// L312
}

template<int NC>
void load2_3(
  hls::stream< ap_int<512> > &v122 /* v122[1] */,
  hls::stream< ap_int<128> > &v123 /* v123[1] */
){
  #pragma HLS inline OFF
  for (int v124 = 0; v124 < 1; v124++) {	// L316
    for (int v125 = 0; v125 < 2; v125++) {	// L317
      for (int v126 = 0; v126 < 2; v126++) {	// L318
        for (int v127 = 0; v127 < 2; v127++) {	// L319
          for (int v128 = 0; v128 < 2; v128++) {	// L320
            for (int v129 = 0; v129 < 16; v129++) {	// L321
              for (int v130 = 0; v130 < 2; v130++) {	// L322
                for (int v131 = 0; v131 < 1; v131++) {	// L323
                #pragma HLS pipeline II=4
                  ap_int<512> v132 = v122.read(); //v122                  v132 = v122;	// L324
                  for (int v133 = 0; v133 < 4; v133++) {	// L325
                  #pragma HLS pipeline II=1
                    int v134 = ((v133 * 128) + 127);	// L326
                    int v135 = (v133 * 128);	// L327
                    ap_int<128> v136 = v132(v134, v135);	// L328
                    v123.write(v136); //v123                    v123 = v136;	// L329
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load2_3_top(
  hls::stream< ap_int<512> > &v137 /* v137[1] */,
  hls::stream< ap_int<128> > &v138 /* v138[1] */,
  hls::stream< ap_int<512> > &v139 /* v139[1] */,
  hls::stream< ap_int<128> > &v140 /* v140[1] */,
  hls::stream< ap_int<512> > &v141 /* v141[1] */,
  hls::stream< ap_int<128> > &v142 /* v142[1] */,
  hls::stream< ap_int<512> > &v143 /* v143[1] */,
  hls::stream< ap_int<128> > &v144 /* v144[1] */
){
  #pragma HLS inline OFF
  load2_3<0>(v137, v138);	// L342
  load2_3<1>(v139, v140);	// L343
  load2_3<2>(v141, v142);	// L344
  load2_3<3>(v143, v144);	// L345
}

void send5_0(
  hls::stream< ap_int<128> > &v145 /* v145[1] */,
  ap_int<128> v146[16][8],
  bool v147
){
  #pragma HLS inline OFF
  if (v147) {	// L349
    for (int v148 = 0; v148 < 2; v148++) {	// L350
      for (int v149 = 0; v149 < 8; v149++) {	// L351
        for (int v150 = 0; v150 < 2; v150++) {	// L352
          for (int v151 = 0; v151 < 4; v151++) {	// L353
          #pragma HLS pipeline II=1
            ap_int<128> v152 = v145.read(); //v145            v152 = v145;	// L354
            v146[(v149 + (v148 * 8))][(v151 + (v150 * 4))] = v152;	// L355
          }
        }
      }
    }
  }
}

void send5_1(
  ap_int<128> v153[16][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v154 /* v154[1] */,
  bool v155
){
  #pragma HLS inline OFF
  if (v155) {	// L364
    for (int v156 = 0; v156 < 2; v156++) {	// L365
      for (int v157 = 0; v157 < 2; v157++) {	// L366
        for (int v158 = 0; v158 < 2; v158++) {	// L367
          for (int v159 = 0; v159 < 2; v159++) {	// L368
            for (int v160 = 0; v160 < 8; v160++) {	// L369
              for (int v161 = 0; v161 < 4; v161++) {	// L370
              #pragma HLS pipeline II=1
                ap_int<128> v162 = v153[(v160 + (v158 * 8))][(v161 + (v157 * 4))];	// L371
                ap_axiu<128, 0 ,0 ,0> v154_axiu;
                v154_axiu.data = v162;
                v154_axiu.keep = -1;
                v154.write(v154_axiu); //v154                v154 = v162;	// L372
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send5(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v163 /* v163[1] */,
  hls::stream< ap_int<128> > &v164 /* v164[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v165[16][8];	// L388
  #pragma HLS bind_storage variable=v165 type=ram_s2p impl=bram
  ap_int<128> v166[16][8];	// L389
  #pragma HLS bind_storage variable=v166 type=ram_s2p impl=bram
  for (int v167 = 0; v167 < 1; v167++) {	// L390
    for (int v168 = 0; v168 < 2; v168++) {	// L391
      for (int v169 = 0; v169 < 2; v169++) {	// L392
        for (int v170 = 0; v170 < 2; v170++) {	// L393
          int v171 = v169 * 2;	// L394
          int v172 = v170 + v171;	// L395
          int v173 = v168 * 4;	// L396
          int v174 = v172 + v173;	// L397
          int v175 = v167 * 8;	// L398
          int v176 = v174 + v175;	// L399
          int v177 = v176 % 2;	// L400
          bool v178 = v177 == 0;	// L401
          bool v179 = v176 != 0;	// L402
          if (v178) {	// L403
            send5_0(v164, v165, 1);	// L404
            send5_1(v166, v163, v179);	// L405
          } else {
            send5_0(v164, v166, 1);	// L407
            send5_1(v165, v163, v179);	// L408
          }
        }
      }
    }
  }
  send5_1(v166, v163, 1);	// L414
}

void send5_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v180 /* v180[1] */,
  hls::stream< ap_int<128> > &v181 /* v181[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v182 /* v182[1] */,
  hls::stream< ap_int<128> > &v183 /* v183[1] */
){
  #pragma HLS inline OFF
  send5<0>(v180, v181);	// L418
  send5<1>(v182, v183);	// L419
}

template<int NC>
void receive2(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v184 /* v184[1] */,
  hls::stream< ap_int<128> > &v185 /* v185[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v186[4][8];	// L432
  #pragma HLS bind_storage variable=v186 type=ram_s2p impl=bram
  for (int v187 = 0; v187 < 4; v187++) {	// L433
    for (int v188 = 0; v188 < 8; v188++) {	// L434
    #pragma HLS pipeline II=1
      v186[v187][v188] = 0;	// L435
    }
  }
  for (int v189 = 0; v189 < 1; v189++) {	// L438
    for (int v190 = 0; v190 < 2; v190++) {	// L439
      for (int v191 = 0; v191 < 2; v191++) {	// L440
        for (int v192 = 0; v192 < 2; v192++) {	// L441
          for (int v193 = 0; v193 < 2; v193++) {	// L442
            for (int v194 = 0; v194 < 2; v194++) {	// L443
              for (int v195 = 0; v195 < 2; v195++) {	// L444
                for (int v196 = 0; v196 < 2; v196++) {	// L445
                  for (int v197 = 0; v197 < 2; v197++) {	// L446
                    for (int v198 = 0; v198 < 4; v198++) {	// L447
                    #pragma HLS pipeline II=1
                      ap_axiu<128, 0 ,0 ,0> v184_axiu = v184.read();
                      ap_int<128> v199 = v184_axiu.data; //v184                      v199 = v184;	// L448
                      ap_int<128> v200 = v186[(v197 + (v193 * 2))][(v198 + (v194 * 4))];	// L449
                      ap_int<128> v201 = v199;
                      ap_int<128> v202 = v200;
                      ap_int<128> v203 = 0;
                      int32_t v204 = v201(31, 0);	// L453
                      int32_t v205 = v202(31, 0);	// L454
                      float v206;
                      union { int32_t from; float to;} _converter_v204_to_v206;
                      _converter_v204_to_v206.from = v204;
                      v206 = _converter_v204_to_v206.to;	// L455
                      float v207;
                      union { int32_t from; float to;} _converter_v205_to_v207;
                      _converter_v205_to_v207.from = v205;
                      v207 = _converter_v205_to_v207.to;	// L456
                      float v208 = v206 + v207;	// L457
                      int32_t v209;
                      union { float from; int32_t to;} _converter_v208_to_v209;
                      _converter_v208_to_v209.from = v208;
                      v209 = _converter_v208_to_v209.to;	// L458
                      v203(31, 0) = v209;	// L459
                      int32_t v210 = v201(63, 32);	// L460
                      int32_t v211 = v202(63, 32);	// L461
                      float v212;
                      union { int32_t from; float to;} _converter_v210_to_v212;
                      _converter_v210_to_v212.from = v210;
                      v212 = _converter_v210_to_v212.to;	// L462
                      float v213;
                      union { int32_t from; float to;} _converter_v211_to_v213;
                      _converter_v211_to_v213.from = v211;
                      v213 = _converter_v211_to_v213.to;	// L463
                      float v214 = v212 + v213;	// L464
                      int32_t v215;
                      union { float from; int32_t to;} _converter_v214_to_v215;
                      _converter_v214_to_v215.from = v214;
                      v215 = _converter_v214_to_v215.to;	// L465
                      v203(63, 32) = v215;	// L466
                      int32_t v216 = v201(95, 64);	// L467
                      int32_t v217 = v202(95, 64);	// L468
                      float v218;
                      union { int32_t from; float to;} _converter_v216_to_v218;
                      _converter_v216_to_v218.from = v216;
                      v218 = _converter_v216_to_v218.to;	// L469
                      float v219;
                      union { int32_t from; float to;} _converter_v217_to_v219;
                      _converter_v217_to_v219.from = v217;
                      v219 = _converter_v217_to_v219.to;	// L470
                      float v220 = v218 + v219;	// L471
                      int32_t v221;
                      union { float from; int32_t to;} _converter_v220_to_v221;
                      _converter_v220_to_v221.from = v220;
                      v221 = _converter_v220_to_v221.to;	// L472
                      v203(95, 64) = v221;	// L473
                      int32_t v222 = v201(127, 96);	// L474
                      int32_t v223 = v202(127, 96);	// L475
                      float v224;
                      union { int32_t from; float to;} _converter_v222_to_v224;
                      _converter_v222_to_v224.from = v222;
                      v224 = _converter_v222_to_v224.to;	// L476
                      float v225;
                      union { int32_t from; float to;} _converter_v223_to_v225;
                      _converter_v223_to_v225.from = v223;
                      v225 = _converter_v223_to_v225.to;	// L477
                      float v226 = v224 + v225;	// L478
                      int32_t v227;
                      union { float from; int32_t to;} _converter_v226_to_v227;
                      _converter_v226_to_v227.from = v226;
                      v227 = _converter_v226_to_v227.to;	// L479
                      v203(127, 96) = v227;	// L480
                      ap_int<128> v228 = v203;
                      v186[(v197 + (v193 * 2))][(v198 + (v194 * 4))] = v228;	// L482
                    }
                  }
                }
              }
            }
          }
          for (int v229 = 0; v229 < 2; v229++) {	// L489
            for (int v230 = 0; v230 < 2; v230++) {	// L490
              for (int v231 = 0; v231 < 2; v231++) {	// L491
                for (int v232 = 0; v232 < 4; v232++) {	// L492
                #pragma HLS pipeline II=1
                  ap_int<128> v233 = v186[(v230 + (v229 * 2))][(v232 + (v231 * 4))];	// L493
                  v185.write(v233); //v185                  v185 = v233;	// L494
                  v186[(v230 + (v229 * 2))][(v232 + (v231 * 4))] = 0;	// L495
                }
              }
            }
          }
        }
      }
    }
  }
}

void receive2_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v234 /* v234[1] */,
  hls::stream< ap_int<128> > &v235 /* v235[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v236 /* v236[1] */,
  hls::stream< ap_int<128> > &v237 /* v237[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v238 /* v238[1] */,
  hls::stream< ap_int<128> > &v239 /* v239[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v240 /* v240[1] */,
  hls::stream< ap_int<128> > &v241 /* v241[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v234, v235);	// L507
  receive2<1>(v236, v237);	// L508
  receive2<2>(v238, v239);	// L509
  receive2<3>(v240, v241);	// L510
}

void send6_0(
  hls::stream< ap_int<128> > &v242 /* v242[1] */,
  ap_int<128> v243[32][8],
  bool v244
){
  #pragma HLS inline OFF
  if (v244) {	// L514
    for (int v245 = 0; v245 < 2; v245++) {	// L515
      for (int v246 = 0; v246 < 16; v246++) {	// L516
        for (int v247 = 0; v247 < 2; v247++) {	// L517
          for (int v248 = 0; v248 < 4; v248++) {	// L518
          #pragma HLS pipeline II=1
            ap_int<128> v249 = v242.read(); //v242            v249 = v242;	// L519
            v243[(v246 + (v245 * 16))][(v248 + (v247 * 4))] = v249;	// L520
          }
        }
      }
    }
  }
}

void send6_1(
  ap_int<128> v250[32][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v251 /* v251[1] */,
  bool v252
){
  #pragma HLS inline OFF
  if (v252) {	// L529
    for (int v253 = 0; v253 < 2; v253++) {	// L530
      for (int v254 = 0; v254 < 2; v254++) {	// L531
        for (int v255 = 0; v255 < 2; v255++) {	// L532
          for (int v256 = 0; v256 < 2; v256++) {	// L533
            for (int v257 = 0; v257 < 16; v257++) {	// L534
              for (int v258 = 0; v258 < 4; v258++) {	// L535
              #pragma HLS pipeline II=1
                ap_int<128> v259 = v250[(v257 + (v256 * 16))][(v258 + (v254 * 4))];	// L536
                ap_axiu<128, 0 ,0 ,0> v251_axiu;
                v251_axiu.data = v259;
                v251_axiu.keep = -1;
                v251.write(v251_axiu); //v251                v251 = v259;	// L537
              }
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send6(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v260 /* v260[1] */,
  hls::stream< ap_int<128> > &v261 /* v261[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v262[32][8];	// L553
  #pragma HLS bind_storage variable=v262 type=ram_t2p impl=uram
  ap_int<128> v263[32][8];	// L554
  #pragma HLS bind_storage variable=v263 type=ram_t2p impl=uram
  for (int v264 = 0; v264 < 1; v264++) {	// L555
    for (int v265 = 0; v265 < 2; v265++) {	// L556
      for (int v266 = 0; v266 < 2; v266++) {	// L557
        for (int v267 = 0; v267 < 2; v267++) {	// L558
          int v268 = v266 * 2;	// L559
          int v269 = v267 + v268;	// L560
          int v270 = v265 * 4;	// L561
          int v271 = v269 + v270;	// L562
          int v272 = v264 * 8;	// L563
          int v273 = v271 + v272;	// L564
          int v274 = v273 % 2;	// L565
          bool v275 = v274 == 0;	// L566
          bool v276 = v273 != 0;	// L567
          if (v275) {	// L568
            send6_0(v261, v262, 1);	// L569
            send6_1(v263, v260, v276);	// L570
          } else {
            send6_0(v261, v263, 1);	// L572
            send6_1(v262, v260, v276);	// L573
          }
        }
      }
    }
  }
  send6_1(v263, v260, 1);	// L579
}

void send6_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v277 /* v277[1] */,
  hls::stream< ap_int<128> > &v278 /* v278[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v279 /* v279[1] */,
  hls::stream< ap_int<128> > &v280 /* v280[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v281 /* v281[1] */,
  hls::stream< ap_int<128> > &v282 /* v282[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v283 /* v283[1] */,
  hls::stream< ap_int<128> > &v284 /* v284[1] */
){
  #pragma HLS inline OFF
  send6<0>(v277, v278);	// L583
  send6<1>(v279, v280);	// L584
  send6<2>(v281, v282);	// L585
  send6<3>(v283, v284);	// L586
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v285 /* v285[1] */,
  hls::stream< ap_int<512> > &v286 /* v286[1] */
){
  #pragma HLS inline OFF
  for (int v287 = 0; v287 < 1; v287++) {	// L591
    for (int v288 = 0; v288 < 2; v288++) {	// L592
      for (int v289 = 0; v289 < 2; v289++) {	// L593
        for (int v290 = 0; v290 < 2; v290++) {	// L594
          for (int v291 = 0; v291 < 2; v291++) {	// L595
            for (int v292 = 0; v292 < 2; v292++) {	// L596
              for (int v293 = 0; v293 < 2; v293++) {	// L597
                for (int v294 = 0; v294 < 1; v294++) {	// L598
                #pragma HLS pipeline II=4
                  ap_int<512> v295 = 0;
                  for (int v296 = 0; v296 < 4; v296++) {	// L600
                  #pragma HLS pipeline II=1
                    ap_int<128> v297 = v285.read(); //v285                    v297 = v285;	// L601
                    int v298 = ((v296 * 128) + 127);	// L602
                    int v299 = (v296 * 128);	// L603
                    v295(v298, v299) = v297;	// L604
                  }
                  v286.write(v295); //v286                  v286 = v295;	// L606
                }
              }
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v300 /* v300[1] */,
  hls::stream< ap_int<512> > &v301 /* v301[1] */,
  hls::stream< ap_int<128> > &v302 /* v302[1] */,
  hls::stream< ap_int<512> > &v303 /* v303[1] */,
  hls::stream< ap_int<128> > &v304 /* v304[1] */,
  hls::stream< ap_int<512> > &v305 /* v305[1] */,
  hls::stream< ap_int<128> > &v306 /* v306[1] */,
  hls::stream< ap_int<512> > &v307 /* v307[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v300, v301);	// L618
  store0_0<1>(v302, v303);	// L619
  store0_0<2>(v304, v305);	// L620
  store0_0<3>(v306, v307);	// L621
}

template<int NC>
void store0(
  ap_int<512> v308[8][8],
  hls::stream< ap_int<512> > &v309 /* v309[1] */,
  hls::stream< ap_int<512> > &v310 /* v310[1] */,
  hls::stream< ap_int<512> > &v311 /* v311[1] */,
  hls::stream< ap_int<512> > &v312 /* v312[1] */
){
  #pragma HLS inline OFF
  for (int v313 = 0; v313 < 1; v313++) {	// L626
    for (int v314 = 0; v314 < 2; v314++) {	// L627
      for (int v315 = 0; v315 < 2; v315++) {	// L628
        for (int v316 = 0; v316 < 2; v316++) {	// L629
          for (int v317 = 0; v317 < 2; v317++) {	// L630
            for (int v318 = 0; v318 < 2; v318++) {	// L631
              for (int v319 = 0; v319 < 2; v319++) {	// L632
                for (int v320 = 0; v320 < 2; v320++) {	// L633
                #pragma HLS pipeline II=1
                  bool v321 = v320 < 1;	// L634
                  ap_int<512> v322;
                  if (v321) {	// L635
                    ap_int<512> v323 = v312.read(); //v312                    v323 = v312;	// L636
                    v322 = v323;	// L637
                  } else {
                    ap_int<512> v324 = v310.read(); //v310                    v324 = v310;	// L639
                    v322 = v324;	// L640
                  }
                  v308[(((v318 + (v317 * 4)) + (v313 * 8)) + 2)][((v320 + (v319 * 2)) + (v314 * 4))] = v322;	// L642
                }
              }
            }
          }
          for (int v325 = 0; v325 < 2; v325++) {	// L647
            for (int v326 = 0; v326 < 2; v326++) {	// L648
              for (int v327 = 0; v327 < 2; v327++) {	// L649
                for (int v328 = 0; v328 < 2; v328++) {	// L650
                #pragma HLS pipeline II=1
                  bool v329 = v328 < 1;	// L651
                  ap_int<512> v330;
                  if (v329) {	// L652
                    ap_int<512> v331 = v309.read(); //v309                    v331 = v309;	// L653
                    v330 = v331;	// L654
                  } else {
                    ap_int<512> v332 = v311.read(); //v311                    v332 = v311;	// L656
                    v330 = v332;	// L657
                  }
                  v308[((v326 + (v325 * 4)) + (v313 * 8))][((v328 + (v327 * 2)) + (v314 * 4))] = v330;	// L659
                }
              }
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v333[8][8],
  hls::stream< ap_int<512> > &v334 /* v334[1] */,
  hls::stream< ap_int<512> > &v335 /* v335[1] */,
  hls::stream< ap_int<512> > &v336 /* v336[1] */,
  hls::stream< ap_int<512> > &v337 /* v337[1] */
){
  #pragma HLS inline OFF
  store0<0>(v333, v334, v335, v336, v337);	// L671
}

template<int NC>
void load0(
  ap_int<512> v338[8][32][8],
  hls::stream< ap_int<512> > &v339 /* v339[1] */,
  hls::stream< ap_int<512> > &v340 /* v340[1] */,
  hls::stream< ap_int<512> > &v341 /* v341[1] */,
  hls::stream< ap_int<512> > &v342 /* v342[1] */
){
  #pragma HLS inline OFF
  for (int v343 = 0; v343 < 1; v343++) {	// L676
    for (int v344 = 0; v344 < 2; v344++) {	// L677
      for (int v345 = 0; v345 < 2; v345++) {	// L678
        for (int v346 = 0; v346 < 2; v346++) {	// L679
          for (int v347 = 0; v347 < 2; v347++) {	// L680
            for (int v348 = 0; v348 < 2; v348++) {	// L681
              for (int v349 = 0; v349 < 2; v349++) {	// L682
                for (int v350 = 0; v350 < 8; v350++) {	// L683
                  for (int v351 = 0; v351 < 2; v351++) {	// L684
                    for (int v352 = 0; v352 < 2; v352++) {	// L685
                    #pragma HLS pipeline II=1
                      ap_int<512> v353 = v338[((v349 + (v347 * 4)) + (v343 * 8))][((v350 + (v348 * 8)) + (v345 * 16))][((v352 + (v351 * 2)) + (v346 * 4))];	// L686
                      bool v354 = v352 < 1;	// L687
                      if (v354) {	// L688
                        v342.write(v353); //v342                        v342 = v353;	// L689
                      } else {
                        v340.write(v353); //v340                        v340 = v353;	// L691
                      }
                    }
                  }
                }
              }
            }
          }
          for (int v355 = 0; v355 < 2; v355++) {	// L699
            for (int v356 = 0; v356 < 2; v356++) {	// L700
              for (int v357 = 0; v357 < 2; v357++) {	// L701
                for (int v358 = 0; v358 < 8; v358++) {	// L702
                  for (int v359 = 0; v359 < 2; v359++) {	// L703
                    for (int v360 = 0; v360 < 2; v360++) {	// L704
                    #pragma HLS pipeline II=1
                      ap_int<512> v361 = v338[(((v357 + (v355 * 4)) + (v343 * 8)) + 2)][((v358 + (v356 * 8)) + (v345 * 16))][((v360 + (v359 * 2)) + (v346 * 4))];	// L705
                      bool v362 = v360 < 1;	// L706
                      if (v362) {	// L707
                        v339.write(v361); //v339                        v339 = v361;	// L708
                      } else {
                        v341.write(v361); //v341                        v341 = v361;	// L710
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load0_top(
  ap_int<512> v363[8][32][8],
  hls::stream< ap_int<512> > &v364 /* v364[1] */,
  hls::stream< ap_int<512> > &v365 /* v365[1] */,
  hls::stream< ap_int<512> > &v366 /* v366[1] */,
  hls::stream< ap_int<512> > &v367 /* v367[1] */
){
  #pragma HLS inline OFF
  load0<0>(v363, v364, v365, v366, v367);	// L725
}

template<int NC>
void load0_3(
  hls::stream< ap_int<512> > &v368 /* v368[1] */,
  hls::stream< ap_int<128> > &v369 /* v369[1] */
){
  #pragma HLS inline OFF
  for (int v370 = 0; v370 < 1; v370++) {	// L729
    for (int v371 = 0; v371 < 2; v371++) {	// L730
      for (int v372 = 0; v372 < 2; v372++) {	// L731
        for (int v373 = 0; v373 < 2; v373++) {	// L732
          for (int v374 = 0; v374 < 2; v374++) {	// L733
            for (int v375 = 0; v375 < 2; v375++) {	// L734
              for (int v376 = 0; v376 < 2; v376++) {	// L735
                for (int v377 = 0; v377 < 8; v377++) {	// L736
                  for (int v378 = 0; v378 < 2; v378++) {	// L737
                    for (int v379 = 0; v379 < 1; v379++) {	// L738
                    #pragma HLS pipeline II=4
                      ap_int<512> v380 = v368.read(); //v368                      v380 = v368;	// L739
                      for (int v381 = 0; v381 < 4; v381++) {	// L740
                      #pragma HLS pipeline II=1
                        int v382 = ((v381 * 128) + 127);	// L741
                        int v383 = (v381 * 128);	// L742
                        ap_int<128> v384 = v380(v382, v383);	// L743
                        v369.write(v384); //v369                        v369 = v384;	// L744
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load0_3_top(
  hls::stream< ap_int<512> > &v385 /* v385[1] */,
  hls::stream< ap_int<128> > &v386 /* v386[1] */,
  hls::stream< ap_int<512> > &v387 /* v387[1] */,
  hls::stream< ap_int<128> > &v388 /* v388[1] */,
  hls::stream< ap_int<512> > &v389 /* v389[1] */,
  hls::stream< ap_int<128> > &v390 /* v390[1] */,
  hls::stream< ap_int<512> > &v391 /* v391[1] */,
  hls::stream< ap_int<128> > &v392 /* v392[1] */
){
  #pragma HLS inline OFF
  load0_3<0>(v385, v386);	// L759
  load0_3<1>(v387, v388);	// L760
  load0_3<2>(v389, v390);	// L761
  load0_3<3>(v391, v392);	// L762
}

template<int NC>
void load1(
  ap_int<512> v393[32][8],
  hls::stream< ap_int<512> > &v394 /* v394[1] */,
  hls::stream< ap_int<512> > &v395 /* v395[1] */
){
  #pragma HLS inline OFF
  for (int v396 = 0; v396 < 1; v396++) {	// L767
    for (int v397 = 0; v397 < 2; v397++) {	// L768
      for (int v398 = 0; v398 < 2; v398++) {	// L769
        for (int v399 = 0; v399 < 2; v399++) {	// L770
          for (int v400 = 0; v400 < 2; v400++) {	// L771
            for (int v401 = 0; v401 < 8; v401++) {	// L772
              for (int v402 = 0; v402 < 2; v402++) {	// L773
                for (int v403 = 0; v403 < 2; v403++) {	// L774
                #pragma HLS pipeline II=1
                  ap_int<512> v404 = v393[((v401 + (v400 * 8)) + (v398 * 16))][((v403 + (v402 * 2)) + (v397 * 4))];	// L775
                  bool v405 = v403 < 1;	// L776
                  if (v405) {	// L777
                    v395.write(v404); //v395                    v395 = v404;	// L778
                  } else {
                    v394.write(v404); //v394                    v394 = v404;	// L780
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load1_top(
  ap_int<512> v406[32][8],
  hls::stream< ap_int<512> > &v407 /* v407[1] */,
  hls::stream< ap_int<512> > &v408 /* v408[1] */
){
  #pragma HLS inline OFF
  load1<0>(v406, v407, v408);	// L793
}

template<int NC>
void load1_1(
  hls::stream< ap_int<512> > &v409 /* v409[1] */,
  hls::stream< ap_int<128> > &v410 /* v410[1] */
){
  #pragma HLS inline OFF
  for (int v411 = 0; v411 < 1; v411++) {	// L797
    for (int v412 = 0; v412 < 2; v412++) {	// L798
      for (int v413 = 0; v413 < 2; v413++) {	// L799
        for (int v414 = 0; v414 < 2; v414++) {	// L800
          for (int v415 = 0; v415 < 2; v415++) {	// L801
            for (int v416 = 0; v416 < 8; v416++) {	// L802
              for (int v417 = 0; v417 < 2; v417++) {	// L803
                for (int v418 = 0; v418 < 1; v418++) {	// L804
                #pragma HLS pipeline II=4
                  ap_int<512> v419 = v409.read(); //v409                  v419 = v409;	// L805
                  for (int v420 = 0; v420 < 4; v420++) {	// L806
                  #pragma HLS pipeline II=1
                    int v421 = ((v420 * 128) + 127);	// L807
                    int v422 = (v420 * 128);	// L808
                    ap_int<128> v423 = v419(v421, v422);	// L809
                    v410.write(v423); //v410                    v410 = v423;	// L810
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

void load1_1_top(
  hls::stream< ap_int<512> > &v424 /* v424[1] */,
  hls::stream< ap_int<128> > &v425 /* v425[1] */,
  hls::stream< ap_int<512> > &v426 /* v426[1] */,
  hls::stream< ap_int<128> > &v427 /* v427[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v424, v425);	// L823
  load1_1<1>(v426, v427);	// L824
}

void mttkrp_pl(
  ap_int<512> v428[8][32][8],
  ap_int<512> v429[32][8],
  ap_int<512> v430[128][8],
  ap_int<512> v431[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v432 /* v432[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v433 /* v433[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v434 /* v434[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v435 /* v435[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v436 /* v436[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v437 /* v437[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v438 /* v438[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v439 /* v439[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v440 /* v440[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v441 /* v441[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v442 /* v442[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v443 /* v443[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v444 /* v444[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v445 /* v445[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v446 /* v446[1] */;	// L829
  hls::stream< ap_int<128> > v447 /* v447[1] */;	// L830
  hls::stream< ap_int<128> > v448 /* v448[1] */;	// L831
  hls::stream< ap_int<128> > v449 /* v449[1] */;	// L832
  hls::stream< ap_int<128> > v450 /* v450[1] */;	// L833
  hls::stream< ap_int<128> > v451 /* v451[1] */;	// L834
  hls::stream< ap_int<128> > v452 /* v452[1] */;	// L835
  hls::stream< ap_int<128> > v453 /* v453[1] */;	// L836
  hls::stream< ap_int<128> > v454 /* v454[1] */;	// L837
  hls::stream< ap_int<128> > v455 /* v455[1] */;	// L838
  hls::stream< ap_int<128> > v456 /* v456[1] */;	// L839
  hls::stream< ap_int<128> > v457 /* v457[1] */;	// L840
  hls::stream< ap_int<128> > v458 /* v458[1] */;	// L841
  hls::stream< ap_int<128> > v459 /* v459[1] */;	// L842
  ap_int<128> v460[4][8];	// L843
  #pragma HLS bind_storage variable=v460 type=ram_s2p impl=bram
  for (int v461 = 0; v461 < 4; v461++) {	// L844
    for (int v462 = 0; v462 < 8; v462++) {	// L845
    #pragma HLS pipeline II=1
      v460[v461][v462] = 0;	// L846
    }
  }
  ap_int<128> v463[4][8];	// L849
  #pragma HLS bind_storage variable=v463 type=ram_s2p impl=bram
  for (int v464 = 0; v464 < 4; v464++) {	// L850
    for (int v465 = 0; v465 < 8; v465++) {	// L851
    #pragma HLS pipeline II=1
      v463[v464][v465] = 0;	// L852
    }
  }
  ap_int<128> v466[4][8];	// L855
  #pragma HLS bind_storage variable=v466 type=ram_s2p impl=bram
  for (int v467 = 0; v467 < 4; v467++) {	// L856
    for (int v468 = 0; v468 < 8; v468++) {	// L857
    #pragma HLS pipeline II=1
      v466[v467][v468] = 0;	// L858
    }
  }
  ap_int<128> v469[4][8];	// L861
  #pragma HLS bind_storage variable=v469 type=ram_s2p impl=bram
  for (int v470 = 0; v470 < 4; v470++) {	// L862
    for (int v471 = 0; v471 < 8; v471++) {	// L863
    #pragma HLS pipeline II=1
      v469[v470][v471] = 0;	// L864
    }
  }
  hls::stream< ap_int<512> > v472 /* v472[1] */;	// L867
  #pragma HLS stream variable=v472 depth=1
  hls::stream< ap_int<512> > v473 /* v473[1] */;	// L868
  #pragma HLS stream variable=v473 depth=1
  hls::stream< ap_int<512> > v474 /* v474[1] */;	// L869
  #pragma HLS stream variable=v474 depth=1
  hls::stream< ap_int<512> > v475 /* v475[1] */;	// L870
  #pragma HLS stream variable=v475 depth=1
  hls::stream< ap_int<512> > v476 /* v476[1] */;	// L871
  #pragma HLS stream variable=v476 depth=1
  hls::stream< ap_int<512> > v477 /* v477[1] */;	// L872
  #pragma HLS stream variable=v477 depth=1
  hls::stream< ap_int<512> > v478 /* v478[1] */;	// L873
  #pragma HLS stream variable=v478 depth=1
  hls::stream< ap_int<512> > v479 /* v479[1] */;	// L874
  #pragma HLS stream variable=v479 depth=1
  hls::stream< ap_int<512> > v480 /* v480[1] */;	// L875
  #pragma HLS stream variable=v480 depth=1
  hls::stream< ap_int<512> > v481 /* v481[1] */;	// L876
  #pragma HLS stream variable=v481 depth=1
  hls::stream< ap_int<512> > v482 /* v482[1] */;	// L877
  #pragma HLS stream variable=v482 depth=1
  hls::stream< ap_int<512> > v483 /* v483[1] */;	// L878
  #pragma HLS stream variable=v483 depth=1
  hls::stream< ap_int<512> > v484 /* v484[1] */;	// L879
  #pragma HLS stream variable=v484 depth=1
  hls::stream< ap_int<512> > v485 /* v485[1] */;	// L880
  #pragma HLS stream variable=v485 depth=1
  send3_top(v438, v456, v443, v451, v436, v450, v442, v459);	// L881
  load2_top(v430, v474, v473, v475, v472);	// L882
  load2_3_top(v475, v457, v474, v455, v473, v453, v472, v452);	// L883
  send5_top(v434, v454, v433, v458);	// L884
  receive2_top(v440, v448, v439, v446, v437, v449, v445, v447);	// L885
  send6_top(v444, v453, v435, v455, v432, v452, v441, v457);	// L886
  store0_0_top(v446, v476, v447, v477, v448, v478, v449, v479);	// L887
  store0_top(v431, v476, v479, v477, v478);	// L888
  load0_top(v428, v481, v482, v480, v483);	// L889
  load0_3_top(v483, v459, v482, v456, v481, v451, v480, v450);	// L890
  load1_top(v429, v484, v485);	// L891
  load1_1_top(v485, v458, v484, v454);	// L892
}

void top(
  ap_int<512> v486[8][32][8],
  ap_int<512> v487[32][8],
  ap_int<512> v488[128][8],
  ap_int<512> v489[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v490 /* v490[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v491 /* v491[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v492 /* v492[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v493 /* v493[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v494 /* v494[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v495 /* v495[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v496 /* v496[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v497 /* v497[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v498 /* v498[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v499 /* v499[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v500 /* v500[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v501 /* v501[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v502 /* v502[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v503 /* v503[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v486
  #pragma HLS interface s_axilite bundle=control port=v486
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v487
  #pragma HLS interface s_axilite bundle=control port=v487
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v488
  #pragma HLS interface s_axilite bundle=control port=v488
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v489
  #pragma HLS interface s_axilite bundle=control port=v489
  #pragma HLS interface axis port=v490
  #pragma HLS interface axis port=v491
  #pragma HLS interface axis port=v492
  #pragma HLS interface axis port=v493
  #pragma HLS interface axis port=v494
  #pragma HLS interface axis port=v495
  #pragma HLS interface axis port=v496
  #pragma HLS interface axis port=v497
  #pragma HLS interface axis port=v498
  #pragma HLS interface axis port=v499
  #pragma HLS interface axis port=v500
  #pragma HLS interface axis port=v501
  #pragma HLS interface axis port=v502
  #pragma HLS interface axis port=v503

  mttkrp_pl(v486, v487, v488, v489, v490, v491, v492, v493, v494, v495, v496, v497, v498, v499, v500, v501, v502, v503);	// L935
}


