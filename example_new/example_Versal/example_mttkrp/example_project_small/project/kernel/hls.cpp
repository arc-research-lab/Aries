
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
                    v100.write(v109); //v100                    v100 = v109;	// L282
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
                    v99.write(v115); //v99                    v99 = v115;	// L297
                  } else {
                    v97.write(v115); //v97                    v97 = v115;	// L299
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
        }
      }
      for (int v229 = 0; v229 < 2; v229++) {	// L491
        for (int v230 = 0; v230 < 2; v230++) {	// L492
          for (int v231 = 0; v231 < 2; v231++) {	// L493
            for (int v232 = 0; v232 < 4; v232++) {	// L494
            #pragma HLS pipeline II=1
              ap_int<128> v233 = v186[(v230 + (v229 * 2))][(v232 + (v231 * 4))];	// L495
              v185.write(v233); //v185              v185 = v233;	// L496
              v186[(v230 + (v229 * 2))][(v232 + (v231 * 4))] = 0;	// L497
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
            for (int v292 = 0; v292 < 1; v292++) {	// L596
            #pragma HLS pipeline II=4
              ap_int<512> v293 = 0;
              for (int v294 = 0; v294 < 4; v294++) {	// L598
              #pragma HLS pipeline II=1
                ap_int<128> v295 = v285.read(); //v285                v295 = v285;	// L599
                int v296 = ((v294 * 128) + 127);	// L600
                int v297 = (v294 * 128);	// L601
                v293(v296, v297) = v295;	// L602
              }
              v286.write(v293); //v286              v286 = v293;	// L604
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v298 /* v298[1] */,
  hls::stream< ap_int<512> > &v299 /* v299[1] */,
  hls::stream< ap_int<128> > &v300 /* v300[1] */,
  hls::stream< ap_int<512> > &v301 /* v301[1] */,
  hls::stream< ap_int<128> > &v302 /* v302[1] */,
  hls::stream< ap_int<512> > &v303 /* v303[1] */,
  hls::stream< ap_int<128> > &v304 /* v304[1] */,
  hls::stream< ap_int<512> > &v305 /* v305[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v298, v299);	// L614
  store0_0<1>(v300, v301);	// L615
  store0_0<2>(v302, v303);	// L616
  store0_0<3>(v304, v305);	// L617
}

template<int NC>
void store0(
  ap_int<512> v306[8][8],
  hls::stream< ap_int<512> > &v307 /* v307[1] */,
  hls::stream< ap_int<512> > &v308 /* v308[1] */,
  hls::stream< ap_int<512> > &v309 /* v309[1] */,
  hls::stream< ap_int<512> > &v310 /* v310[1] */
){
  #pragma HLS inline OFF
  for (int v311 = 0; v311 < 1; v311++) {	// L622
    for (int v312 = 0; v312 < 2; v312++) {	// L623
      for (int v313 = 0; v313 < 2; v313++) {	// L624
        for (int v314 = 0; v314 < 2; v314++) {	// L625
          for (int v315 = 0; v315 < 2; v315++) {	// L626
            for (int v316 = 0; v316 < 2; v316++) {	// L627
            #pragma HLS pipeline II=1
              bool v317 = v316 < 1;	// L628
              ap_int<512> v318;
              if (v317) {	// L629
                ap_int<512> v319 = v307.read(); //v307                v319 = v307;	// L630
                v318 = v319;	// L631
              } else {
                ap_int<512> v320 = v309.read(); //v309                v320 = v309;	// L633
                v318 = v320;	// L634
              }
              v306[((v314 + (v313 * 4)) + (v311 * 8))][((v316 + (v315 * 2)) + (v312 * 4))] = v318;	// L636
            }
          }
        }
      }
      for (int v321 = 0; v321 < 2; v321++) {	// L641
        for (int v322 = 0; v322 < 2; v322++) {	// L642
          for (int v323 = 0; v323 < 2; v323++) {	// L643
            for (int v324 = 0; v324 < 2; v324++) {	// L644
            #pragma HLS pipeline II=1
              bool v325 = v324 < 1;	// L645
              ap_int<512> v326;
              if (v325) {	// L646
                ap_int<512> v327 = v308.read(); //v308                v327 = v308;	// L647
                v326 = v327;	// L648
              } else {
                ap_int<512> v328 = v310.read(); //v310                v328 = v310;	// L650
                v326 = v328;	// L651
              }
              v306[(((v322 + (v321 * 4)) + (v311 * 8)) + 2)][((v324 + (v323 * 2)) + (v312 * 4))] = v326;	// L653
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v329[8][8],
  hls::stream< ap_int<512> > &v330 /* v330[1] */,
  hls::stream< ap_int<512> > &v331 /* v331[1] */,
  hls::stream< ap_int<512> > &v332 /* v332[1] */,
  hls::stream< ap_int<512> > &v333 /* v333[1] */
){
  #pragma HLS inline OFF
  store0<0>(v329, v330, v331, v332, v333);	// L663
}

template<int NC>
void load0(
  ap_int<512> v334[8][32][8],
  hls::stream< ap_int<512> > &v335 /* v335[1] */,
  hls::stream< ap_int<512> > &v336 /* v336[1] */,
  hls::stream< ap_int<512> > &v337 /* v337[1] */,
  hls::stream< ap_int<512> > &v338 /* v338[1] */
){
  #pragma HLS inline OFF
  for (int v339 = 0; v339 < 1; v339++) {	// L668
    for (int v340 = 0; v340 < 2; v340++) {	// L669
      for (int v341 = 0; v341 < 2; v341++) {	// L670
        for (int v342 = 0; v342 < 2; v342++) {	// L671
          for (int v343 = 0; v343 < 2; v343++) {	// L672
            for (int v344 = 0; v344 < 2; v344++) {	// L673
              for (int v345 = 0; v345 < 2; v345++) {	// L674
                for (int v346 = 0; v346 < 8; v346++) {	// L675
                  for (int v347 = 0; v347 < 2; v347++) {	// L676
                    for (int v348 = 0; v348 < 2; v348++) {	// L677
                    #pragma HLS pipeline II=1
                      ap_int<512> v349 = v334[((v345 + (v343 * 4)) + (v339 * 8))][((v346 + (v344 * 8)) + (v341 * 16))][((v348 + (v347 * 2)) + (v342 * 4))];	// L678
                      bool v350 = v348 < 1;	// L679
                      if (v350) {	// L680
                        v336.write(v349); //v336                        v336 = v349;	// L681
                      } else {
                        v337.write(v349); //v337                        v337 = v349;	// L683
                      }
                    }
                  }
                }
              }
            }
          }
          for (int v351 = 0; v351 < 2; v351++) {	// L691
            for (int v352 = 0; v352 < 2; v352++) {	// L692
              for (int v353 = 0; v353 < 2; v353++) {	// L693
                for (int v354 = 0; v354 < 8; v354++) {	// L694
                  for (int v355 = 0; v355 < 2; v355++) {	// L695
                    for (int v356 = 0; v356 < 2; v356++) {	// L696
                    #pragma HLS pipeline II=1
                      ap_int<512> v357 = v334[(((v353 + (v351 * 4)) + (v339 * 8)) + 2)][((v354 + (v352 * 8)) + (v341 * 16))][((v356 + (v355 * 2)) + (v342 * 4))];	// L697
                      bool v358 = v356 < 1;	// L698
                      if (v358) {	// L699
                        v338.write(v357); //v338                        v338 = v357;	// L700
                      } else {
                        v335.write(v357); //v335                        v335 = v357;	// L702
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
  ap_int<512> v359[8][32][8],
  hls::stream< ap_int<512> > &v360 /* v360[1] */,
  hls::stream< ap_int<512> > &v361 /* v361[1] */,
  hls::stream< ap_int<512> > &v362 /* v362[1] */,
  hls::stream< ap_int<512> > &v363 /* v363[1] */
){
  #pragma HLS inline OFF
  load0<0>(v359, v360, v361, v362, v363);	// L717
}

template<int NC>
void load0_3(
  hls::stream< ap_int<512> > &v364 /* v364[1] */,
  hls::stream< ap_int<128> > &v365 /* v365[1] */
){
  #pragma HLS inline OFF
  for (int v366 = 0; v366 < 1; v366++) {	// L721
    for (int v367 = 0; v367 < 2; v367++) {	// L722
      for (int v368 = 0; v368 < 2; v368++) {	// L723
        for (int v369 = 0; v369 < 2; v369++) {	// L724
          for (int v370 = 0; v370 < 2; v370++) {	// L725
            for (int v371 = 0; v371 < 2; v371++) {	// L726
              for (int v372 = 0; v372 < 2; v372++) {	// L727
                for (int v373 = 0; v373 < 8; v373++) {	// L728
                  for (int v374 = 0; v374 < 2; v374++) {	// L729
                    for (int v375 = 0; v375 < 1; v375++) {	// L730
                    #pragma HLS pipeline II=4
                      ap_int<512> v376 = v364.read(); //v364                      v376 = v364;	// L731
                      for (int v377 = 0; v377 < 4; v377++) {	// L732
                      #pragma HLS pipeline II=1
                        int v378 = ((v377 * 128) + 127);	// L733
                        int v379 = (v377 * 128);	// L734
                        ap_int<128> v380 = v376(v378, v379);	// L735
                        v365.write(v380); //v365                        v365 = v380;	// L736
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
  hls::stream< ap_int<512> > &v381 /* v381[1] */,
  hls::stream< ap_int<128> > &v382 /* v382[1] */,
  hls::stream< ap_int<512> > &v383 /* v383[1] */,
  hls::stream< ap_int<128> > &v384 /* v384[1] */,
  hls::stream< ap_int<512> > &v385 /* v385[1] */,
  hls::stream< ap_int<128> > &v386 /* v386[1] */,
  hls::stream< ap_int<512> > &v387 /* v387[1] */,
  hls::stream< ap_int<128> > &v388 /* v388[1] */
){
  #pragma HLS inline OFF
  load0_3<0>(v381, v382);	// L751
  load0_3<1>(v383, v384);	// L752
  load0_3<2>(v385, v386);	// L753
  load0_3<3>(v387, v388);	// L754
}

template<int NC>
void load1(
  ap_int<512> v389[32][8],
  hls::stream< ap_int<512> > &v390 /* v390[1] */,
  hls::stream< ap_int<512> > &v391 /* v391[1] */
){
  #pragma HLS inline OFF
  for (int v392 = 0; v392 < 1; v392++) {	// L759
    for (int v393 = 0; v393 < 2; v393++) {	// L760
      for (int v394 = 0; v394 < 2; v394++) {	// L761
        for (int v395 = 0; v395 < 2; v395++) {	// L762
          for (int v396 = 0; v396 < 2; v396++) {	// L763
            for (int v397 = 0; v397 < 8; v397++) {	// L764
              for (int v398 = 0; v398 < 2; v398++) {	// L765
                for (int v399 = 0; v399 < 2; v399++) {	// L766
                #pragma HLS pipeline II=1
                  ap_int<512> v400 = v389[((v397 + (v396 * 8)) + (v394 * 16))][((v399 + (v398 * 2)) + (v393 * 4))];	// L767
                  bool v401 = v399 < 1;	// L768
                  if (v401) {	// L769
                    v391.write(v400); //v391                    v391 = v400;	// L770
                  } else {
                    v390.write(v400); //v390                    v390 = v400;	// L772
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
  ap_int<512> v402[32][8],
  hls::stream< ap_int<512> > &v403 /* v403[1] */,
  hls::stream< ap_int<512> > &v404 /* v404[1] */
){
  #pragma HLS inline OFF
  load1<0>(v402, v403, v404);	// L785
}

template<int NC>
void load1_1(
  hls::stream< ap_int<512> > &v405 /* v405[1] */,
  hls::stream< ap_int<128> > &v406 /* v406[1] */
){
  #pragma HLS inline OFF
  for (int v407 = 0; v407 < 1; v407++) {	// L789
    for (int v408 = 0; v408 < 2; v408++) {	// L790
      for (int v409 = 0; v409 < 2; v409++) {	// L791
        for (int v410 = 0; v410 < 2; v410++) {	// L792
          for (int v411 = 0; v411 < 2; v411++) {	// L793
            for (int v412 = 0; v412 < 8; v412++) {	// L794
              for (int v413 = 0; v413 < 2; v413++) {	// L795
                for (int v414 = 0; v414 < 1; v414++) {	// L796
                #pragma HLS pipeline II=4
                  ap_int<512> v415 = v405.read(); //v405                  v415 = v405;	// L797
                  for (int v416 = 0; v416 < 4; v416++) {	// L798
                  #pragma HLS pipeline II=1
                    int v417 = ((v416 * 128) + 127);	// L799
                    int v418 = (v416 * 128);	// L800
                    ap_int<128> v419 = v415(v417, v418);	// L801
                    v406.write(v419); //v406                    v406 = v419;	// L802
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
  hls::stream< ap_int<512> > &v420 /* v420[1] */,
  hls::stream< ap_int<128> > &v421 /* v421[1] */,
  hls::stream< ap_int<512> > &v422 /* v422[1] */,
  hls::stream< ap_int<128> > &v423 /* v423[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v420, v421);	// L815
  load1_1<1>(v422, v423);	// L816
}

void mttkrp_pl(
  ap_int<512> v424[8][32][8],
  ap_int<512> v425[32][8],
  ap_int<512> v426[128][8],
  ap_int<512> v427[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v428 /* v428[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v429 /* v429[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v430 /* v430[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v431 /* v431[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v432 /* v432[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v433 /* v433[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v434 /* v434[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v435 /* v435[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v436 /* v436[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v437 /* v437[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v438 /* v438[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v439 /* v439[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v440 /* v440[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v441 /* v441[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v442 /* v442[1] */;	// L821
  hls::stream< ap_int<128> > v443 /* v443[1] */;	// L822
  hls::stream< ap_int<128> > v444 /* v444[1] */;	// L823
  hls::stream< ap_int<128> > v445 /* v445[1] */;	// L824
  hls::stream< ap_int<128> > v446 /* v446[1] */;	// L825
  hls::stream< ap_int<128> > v447 /* v447[1] */;	// L826
  hls::stream< ap_int<128> > v448 /* v448[1] */;	// L827
  hls::stream< ap_int<128> > v449 /* v449[1] */;	// L828
  hls::stream< ap_int<128> > v450 /* v450[1] */;	// L829
  hls::stream< ap_int<128> > v451 /* v451[1] */;	// L830
  hls::stream< ap_int<128> > v452 /* v452[1] */;	// L831
  hls::stream< ap_int<128> > v453 /* v453[1] */;	// L832
  hls::stream< ap_int<128> > v454 /* v454[1] */;	// L833
  hls::stream< ap_int<128> > v455 /* v455[1] */;	// L834
  ap_int<128> v456[4][8];	// L835
  #pragma HLS bind_storage variable=v456 type=ram_s2p impl=bram
  for (int v457 = 0; v457 < 4; v457++) {	// L836
    for (int v458 = 0; v458 < 8; v458++) {	// L837
    #pragma HLS pipeline II=1
      v456[v457][v458] = 0;	// L838
    }
  }
  ap_int<128> v459[4][8];	// L841
  #pragma HLS bind_storage variable=v459 type=ram_s2p impl=bram
  for (int v460 = 0; v460 < 4; v460++) {	// L842
    for (int v461 = 0; v461 < 8; v461++) {	// L843
    #pragma HLS pipeline II=1
      v459[v460][v461] = 0;	// L844
    }
  }
  ap_int<128> v462[4][8];	// L847
  #pragma HLS bind_storage variable=v462 type=ram_s2p impl=bram
  for (int v463 = 0; v463 < 4; v463++) {	// L848
    for (int v464 = 0; v464 < 8; v464++) {	// L849
    #pragma HLS pipeline II=1
      v462[v463][v464] = 0;	// L850
    }
  }
  ap_int<128> v465[4][8];	// L853
  #pragma HLS bind_storage variable=v465 type=ram_s2p impl=bram
  for (int v466 = 0; v466 < 4; v466++) {	// L854
    for (int v467 = 0; v467 < 8; v467++) {	// L855
    #pragma HLS pipeline II=1
      v465[v466][v467] = 0;	// L856
    }
  }
  hls::stream< ap_int<512> > v468 /* v468[1] */;	// L859
  #pragma HLS stream variable=v468 depth=1
  hls::stream< ap_int<512> > v469 /* v469[1] */;	// L860
  #pragma HLS stream variable=v469 depth=1
  hls::stream< ap_int<512> > v470 /* v470[1] */;	// L861
  #pragma HLS stream variable=v470 depth=1
  hls::stream< ap_int<512> > v471 /* v471[1] */;	// L862
  #pragma HLS stream variable=v471 depth=1
  hls::stream< ap_int<512> > v472 /* v472[1] */;	// L863
  #pragma HLS stream variable=v472 depth=1
  hls::stream< ap_int<512> > v473 /* v473[1] */;	// L864
  #pragma HLS stream variable=v473 depth=1
  hls::stream< ap_int<512> > v474 /* v474[1] */;	// L865
  #pragma HLS stream variable=v474 depth=1
  hls::stream< ap_int<512> > v475 /* v475[1] */;	// L866
  #pragma HLS stream variable=v475 depth=1
  hls::stream< ap_int<512> > v476 /* v476[1] */;	// L867
  #pragma HLS stream variable=v476 depth=1
  hls::stream< ap_int<512> > v477 /* v477[1] */;	// L868
  #pragma HLS stream variable=v477 depth=1
  hls::stream< ap_int<512> > v478 /* v478[1] */;	// L869
  #pragma HLS stream variable=v478 depth=1
  hls::stream< ap_int<512> > v479 /* v479[1] */;	// L870
  #pragma HLS stream variable=v479 depth=1
  hls::stream< ap_int<512> > v480 /* v480[1] */;	// L871
  #pragma HLS stream variable=v480 depth=1
  hls::stream< ap_int<512> > v481 /* v481[1] */;	// L872
  #pragma HLS stream variable=v481 depth=1
  send3_top(v435, v452, v434, v447, v428, v446, v429, v455);	// L873
  load2_top(v426, v468, v469, v470, v471);	// L874
  load2_3_top(v471, v453, v470, v451, v469, v449, v468, v448);	// L875
  send5_top(v439, v450, v440, v454);	// L876
  receive2_top(v430, v444, v438, v442, v431, v445, v441, v443);	// L877
  send6_top(v436, v449, v437, v451, v433, v448, v432, v453);	// L878
  store0_0_top(v445, v472, v444, v473, v443, v474, v442, v475);	// L879
  store0_top(v427, v475, v473, v474, v472);	// L880
  load0_top(v424, v476, v479, v478, v477);	// L881
  load0_3_top(v479, v455, v478, v452, v477, v447, v476, v446);	// L882
  load1_top(v425, v480, v481);	// L883
  load1_1_top(v481, v454, v480, v450);	// L884
}

void top(
  ap_int<512> v482[8][32][8],
  ap_int<512> v483[32][8],
  ap_int<512> v484[128][8],
  ap_int<512> v485[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v486 /* v486[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v487 /* v487[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v488 /* v488[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v489 /* v489[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v490 /* v490[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v491 /* v491[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v492 /* v492[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v493 /* v493[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v494 /* v494[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v495 /* v495[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v496 /* v496[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v497 /* v497[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v498 /* v498[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v499 /* v499[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v482
  #pragma HLS interface s_axilite bundle=control port=v482
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v483
  #pragma HLS interface s_axilite bundle=control port=v483
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v484
  #pragma HLS interface s_axilite bundle=control port=v484
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v485
  #pragma HLS interface s_axilite bundle=control port=v485
  #pragma HLS interface axis port=v486
  #pragma HLS interface axis port=v487
  #pragma HLS interface axis port=v488
  #pragma HLS interface axis port=v489
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

  mttkrp_pl(v482, v483, v484, v485, v486, v487, v488, v489, v490, v491, v492, v493, v494, v495, v496, v497, v498, v499);	// L927
}


