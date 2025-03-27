
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
  hls::stream< ap_int<128> > &v48 /* v48[1] */,
  ap_int<128> v49[4][8][8],
  bool v50
){
  #pragma HLS inline OFF
  if (v50) {	// L192
    for (int v51 = 0; v51 < 2; v51++) {	// L193
      for (int v52 = 0; v52 < 2; v52++) {	// L194
        for (int v53 = 0; v53 < 2; v53++) {	// L195
          for (int v54 = 0; v54 < 4; v54++) {	// L196
            for (int v55 = 0; v55 < 2; v55++) {	// L197
              for (int v56 = 0; v56 < 4; v56++) {	// L198
              #pragma HLS pipeline II=1
                ap_int<128> v57 = v48.read(); //v48                v57 = v48;	// L199
                v49[(v53 + (v51 * 2))][(v54 + (v52 * 4))][(v56 + (v55 * 4))] = v57;	// L200
              }
            }
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v58[4][8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v59 /* v59[1] */,
  bool v60
){
  #pragma HLS inline OFF
  if (v60) {	// L211
    for (int v61 = 0; v61 < 2; v61++) {	// L212
      for (int v62 = 0; v62 < 2; v62++) {	// L213
        for (int v63 = 0; v63 < 2; v63++) {	// L214
          for (int v64 = 0; v64 < 2; v64++) {	// L215
            for (int v65 = 0; v65 < 2; v65++) {	// L216
              for (int v66 = 0; v66 < 2; v66++) {	// L217
                for (int v67 = 0; v67 < 4; v67++) {	// L218
                  for (int v68 = 0; v68 < 4; v68++) {	// L219
                  #pragma HLS pipeline II=1
                    ap_int<128> v69 = v58[(v66 + (v61 * 2))][(v67 + (v64 * 4))][(v68 + (v65 * 4))];	// L220
                    ap_axiu<128, 0 ,0 ,0> v59_axiu;
                    v59_axiu.data = v69;
                    v59_axiu.keep = -1;
                    v59.write(v59_axiu); //v59                    v59 = v69;	// L221
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

template<int NC>
void send3(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v70 /* v70[1] */,
  hls::stream< ap_int<128> > &v71 /* v71[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v72[4][8][8];	// L240
  #pragma HLS bind_storage variable=v72 type=ram_t2p impl=uram
  ap_int<128> v73[4][8][8];	// L241
  #pragma HLS bind_storage variable=v73 type=ram_t2p impl=uram
  for (int v74 = 0; v74 < 2; v74++) {	// L242
    for (int v75 = 0; v75 < 2; v75++) {	// L243
      for (int v76 = 0; v76 < 2; v76++) {	// L244
        for (int v77 = 0; v77 < 2; v77++) {	// L245
          for (int v78 = 0; v78 < 2; v78++) {	// L246
            int v79 = v77 * 2;	// L247
            int v80 = v78 + v79;	// L248
            int v81 = v76 * 4;	// L249
            int v82 = v80 + v81;	// L250
            int v83 = v75 * 8;	// L251
            int v84 = v82 + v83;	// L252
            int v85 = v74 * 16;	// L253
            int v86 = v84 + v85;	// L254
            int v87 = v86 % 2;	// L255
            bool v88 = v87 == 0;	// L256
            bool v89 = v86 != 0;	// L257
            if (v88) {	// L258
              send3_0(v71, v72, 1);	// L259
              send3_1(v73, v70, v89);	// L260
            } else {
              send3_0(v71, v73, 1);	// L262
              send3_1(v72, v70, v89);	// L263
            }
          }
        }
      }
    }
  }
  send3_1(v73, v70, 1);	// L270
}

void send3_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v90 /* v90[1] */,
  hls::stream< ap_int<128> > &v91 /* v91[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v92 /* v92[1] */,
  hls::stream< ap_int<128> > &v93 /* v93[1] */
){
  #pragma HLS inline OFF
  send3<0>(v90, v91);	// L274
  send3<1>(v92, v93);	// L275
}

template<int NC>
void load2(
  ap_int<128> v94[128][16],
  hls::stream< ap_int<128> > &v95 /* v95[1] */,
  hls::stream< ap_int<128> > &v96 /* v96[1] */,
  hls::stream< ap_int<128> > &v97 /* v97[1] */,
  hls::stream< ap_int<128> > &v98 /* v98[1] */
){
  #pragma HLS inline OFF
  for (int v99 = 0; v99 < 2; v99++) {	// L280
    for (int v100 = 0; v100 < 2; v100++) {	// L281
      for (int v101 = 0; v101 < 2; v101++) {	// L282
        for (int v102 = 0; v102 < 2; v102++) {	// L283
          for (int v103 = 0; v103 < 2; v103++) {	// L284
            for (int v104 = 0; v104 < 2; v104++) {	// L285
              for (int v105 = 0; v105 < 16; v105++) {	// L286
                for (int v106 = 0; v106 < 2; v106++) {	// L287
                  for (int v107 = 0; v107 < 4; v107++) {	// L288
                  #pragma HLS pipeline II=1
                    ap_int<128> v108 = v94[((v105 + (v104 * 32)) + (v103 * 64))][((v107 + (v106 * 4)) + (v101 * 8))];	// L289
                    bool v109 = v107 < 2;	// L290
                    if (v109) {	// L291
                      v95.write(v108); //v95                      v95 = v108;	// L292
                    } else {
                      v96.write(v108); //v96                      v96 = v108;	// L294
                    }
                  }
                }
              }
            }
            for (int v110 = 0; v110 < 2; v110++) {	// L300
              for (int v111 = 0; v111 < 16; v111++) {	// L301
                for (int v112 = 0; v112 < 2; v112++) {	// L302
                  for (int v113 = 0; v113 < 4; v113++) {	// L303
                  #pragma HLS pipeline II=1
                    ap_int<128> v114 = v94[(((v111 + (v110 * 32)) + (v103 * 64)) + 16)][((v113 + (v112 * 4)) + (v101 * 8))];	// L304
                    bool v115 = v113 < 2;	// L305
                    if (v115) {	// L306
                      v97.write(v114); //v97                      v97 = v114;	// L307
                    } else {
                      v98.write(v114); //v98                      v98 = v114;	// L309
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

void load2_top(
  ap_int<128> v116[128][16],
  hls::stream< ap_int<128> > &v117 /* v117[1] */,
  hls::stream< ap_int<128> > &v118 /* v118[1] */,
  hls::stream< ap_int<128> > &v119 /* v119[1] */,
  hls::stream< ap_int<128> > &v120 /* v120[1] */
){
  #pragma HLS inline OFF
  load2<0>(v116, v117, v118, v119, v120);	// L323
}

void send5_0(
  hls::stream< ap_int<128> > &v121 /* v121[1] */,
  ap_int<128> v122[32][4],
  bool v123
){
  #pragma HLS inline OFF
  if (v123) {	// L327
    for (int v124 = 0; v124 < 2; v124++) {	// L328
      for (int v125 = 0; v125 < 16; v125++) {	// L329
        for (int v126 = 0; v126 < 2; v126++) {	// L330
          for (int v127 = 0; v127 < 2; v127++) {	// L331
          #pragma HLS pipeline II=1
            ap_int<128> v128 = v121.read(); //v121            v128 = v121;	// L332
            v122[(v125 + (v124 * 16))][(v127 + (v126 * 2))] = v128;	// L333
          }
        }
      }
    }
  }
}

void send5_1(
  ap_int<128> v129[32][4],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v130 /* v130[1] */,
  bool v131
){
  #pragma HLS inline OFF
  if (v131) {	// L342
    for (int v132 = 0; v132 < 2; v132++) {	// L343
      for (int v133 = 0; v133 < 2; v133++) {	// L344
        for (int v134 = 0; v134 < 2; v134++) {	// L345
          for (int v135 = 0; v135 < 2; v135++) {	// L346
            for (int v136 = 0; v136 < 2; v136++) {	// L347
              for (int v137 = 0; v137 < 16; v137++) {	// L348
                for (int v138 = 0; v138 < 2; v138++) {	// L349
                #pragma HLS pipeline II=1
                  ap_int<128> v139 = v129[(v137 + (v136 * 16))][(v138 + (v134 * 2))];	// L350
                  ap_axiu<128, 0 ,0 ,0> v130_axiu;
                  v130_axiu.data = v139;
                  v130_axiu.keep = -1;
                  v130.write(v130_axiu); //v130                  v130 = v139;	// L351
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
void send5(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v140 /* v140[1] */,
  hls::stream< ap_int<128> > &v141 /* v141[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v142[32][4];	// L369
  #pragma HLS bind_storage variable=v142 type=ram_t2p impl=uram
  ap_int<128> v143[32][4];	// L370
  #pragma HLS bind_storage variable=v143 type=ram_t2p impl=uram
  for (int v144 = 0; v144 < 2; v144++) {	// L371
    for (int v145 = 0; v145 < 2; v145++) {	// L372
      for (int v146 = 0; v146 < 2; v146++) {	// L373
        for (int v147 = 0; v147 < 2; v147++) {	// L374
          for (int v148 = 0; v148 < 2; v148++) {	// L375
            int v149 = v147 * 2;	// L376
            int v150 = v148 + v149;	// L377
            int v151 = v146 * 4;	// L378
            int v152 = v150 + v151;	// L379
            int v153 = v145 * 8;	// L380
            int v154 = v152 + v153;	// L381
            int v155 = v144 * 16;	// L382
            int v156 = v154 + v155;	// L383
            int v157 = v156 % 2;	// L384
            bool v158 = v157 == 0;	// L385
            bool v159 = v156 != 0;	// L386
            if (v158) {	// L387
              send5_0(v141, v142, 1);	// L388
              send5_1(v143, v140, v159);	// L389
            } else {
              send5_0(v141, v143, 1);	// L391
              send5_1(v142, v140, v159);	// L392
            }
          }
        }
      }
    }
  }
  send5_1(v143, v140, 1);	// L399
}

void send5_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v160 /* v160[1] */,
  hls::stream< ap_int<128> > &v161 /* v161[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v162 /* v162[1] */,
  hls::stream< ap_int<128> > &v163 /* v163[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v164 /* v164[1] */,
  hls::stream< ap_int<128> > &v165 /* v165[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v166 /* v166[1] */,
  hls::stream< ap_int<128> > &v167 /* v167[1] */
){
  #pragma HLS inline OFF
  send5<0>(v160, v161);	// L403
  send5<1>(v162, v163);	// L404
  send5<2>(v164, v165);	// L405
  send5<3>(v166, v167);	// L406
}

void send1_0(
  hls::stream< ap_int<128> > &v168 /* v168[1] */,
  ap_int<128> v169[8][2],
  bool v170
){
  #pragma HLS inline OFF
  if (v170) {	// L410
    for (int v171 = 0; v171 < 2; v171++) {	// L411
      for (int v172 = 0; v172 < 4; v172++) {	// L412
        for (int v173 = 0; v173 < 2; v173++) {	// L413
          for (int v174 = 0; v174 < 1; v174++) {	// L414
          #pragma HLS pipeline II=1
            ap_int<128> v175 = v168.read(); //v168            v175 = v168;	// L415
            v169[(v172 + (v171 * 4))][(v174 + v173)] = v175;	// L416
          }
        }
      }
    }
  }
}

void send1_1(
  ap_int<128> v176[8][2],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v177 /* v177[1] */,
  bool v178
){
  #pragma HLS inline OFF
  if (v178) {	// L425
    for (int v179 = 0; v179 < 2; v179++) {	// L426
      for (int v180 = 0; v180 < 2; v180++) {	// L427
        for (int v181 = 0; v181 < 2; v181++) {	// L428
          for (int v182 = 0; v182 < 2; v182++) {	// L429
            for (int v183 = 0; v183 < 2; v183++) {	// L430
              for (int v184 = 0; v184 < 4; v184++) {	// L431
                for (int v185 = 0; v185 < 1; v185++) {	// L432
                #pragma HLS pipeline II=1
                  ap_int<128> v186 = v176[(v184 + (v182 * 4))][(v185 + v180)];	// L433
                  ap_axiu<128, 0 ,0 ,0> v177_axiu;
                  v177_axiu.data = v186;
                  v177_axiu.keep = -1;
                  v177.write(v177_axiu); //v177                  v177 = v186;	// L434
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
void send1(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v187 /* v187[1] */,
  hls::stream< ap_int<128> > &v188 /* v188[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v189[8][2];	// L452
  #pragma HLS bind_storage variable=v189 type=ram_s2p impl=bram
  ap_int<128> v190[8][2];	// L453
  #pragma HLS bind_storage variable=v190 type=ram_s2p impl=bram
  for (int v191 = 0; v191 < 2; v191++) {	// L454
    for (int v192 = 0; v192 < 2; v192++) {	// L455
      for (int v193 = 0; v193 < 2; v193++) {	// L456
        for (int v194 = 0; v194 < 2; v194++) {	// L457
          for (int v195 = 0; v195 < 2; v195++) {	// L458
            int v196 = v194 * 2;	// L459
            int v197 = v195 + v196;	// L460
            int v198 = v193 * 4;	// L461
            int v199 = v197 + v198;	// L462
            int v200 = v192 * 8;	// L463
            int v201 = v199 + v200;	// L464
            int v202 = v191 * 16;	// L465
            int v203 = v201 + v202;	// L466
            int v204 = v203 % 2;	// L467
            bool v205 = v204 == 0;	// L468
            bool v206 = v203 != 0;	// L469
            if (v205) {	// L470
              send1_0(v188, v189, 1);	// L471
              send1_1(v190, v187, v206);	// L472
            } else {
              send1_0(v188, v190, 1);	// L474
              send1_1(v189, v187, v206);	// L475
            }
          }
        }
      }
    }
  }
  send1_1(v190, v187, 1);	// L482
}

void send1_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v207 /* v207[1] */,
  hls::stream< ap_int<128> > &v208 /* v208[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v209 /* v209[1] */,
  hls::stream< ap_int<128> > &v210 /* v210[1] */
){
  #pragma HLS inline OFF
  send1<0>(v207, v208);	// L486
  send1<1>(v209, v210);	// L487
}

template<int NC>
void receive2(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v211 /* v211[1] */,
  hls::stream< ap_int<128> > &v212 /* v212[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v213[4][8][4];	// L500
  #pragma HLS bind_storage variable=v213 type=ram_s2p impl=bram
  for (int v214 = 0; v214 < 4; v214++) {	// L501
    for (int v215 = 0; v215 < 8; v215++) {	// L502
      for (int v216 = 0; v216 < 4; v216++) {	// L503
      #pragma HLS pipeline II=1
        v213[v214][v215][v216] = 0;	// L504
      }
    }
  }
  for (int v217 = 0; v217 < 2; v217++) {	// L508
    for (int v218 = 0; v218 < 2; v218++) {	// L509
      for (int v219 = 0; v219 < 2; v219++) {	// L510
        for (int v220 = 0; v220 < 2; v220++) {	// L511
          for (int v221 = 0; v221 < 2; v221++) {	// L512
            for (int v222 = 0; v222 < 2; v222++) {	// L513
              for (int v223 = 0; v223 < 2; v223++) {	// L514
                for (int v224 = 0; v224 < 2; v224++) {	// L515
                  for (int v225 = 0; v225 < 2; v225++) {	// L516
                    for (int v226 = 0; v226 < 2; v226++) {	// L517
                      for (int v227 = 0; v227 < 2; v227++) {	// L518
                        for (int v228 = 0; v228 < 4; v228++) {	// L519
                          for (int v229 = 0; v229 < 2; v229++) {	// L520
                          #pragma HLS pipeline II=1
                            ap_axiu<128, 0 ,0 ,0> v211_axiu = v211.read();
                            ap_int<128> v230 = v211_axiu.data; //v211                            v230 = v211;	// L521
                            ap_int<128> v231 = v213[(v227 + (v222 * 2))][(v228 + (v223 * 4))][(v229 + (v224 * 2))];	// L522
                            ap_int<128> v232 = v230;
                            ap_int<128> v233 = v231;
                            ap_int<128> v234 = 0;
                            int32_t v235 = v232(31, 0);	// L526
                            int32_t v236 = v233(31, 0);	// L527
                            float v237;
                            union { int32_t from; float to;} _converter_v235_to_v237;
                            _converter_v235_to_v237.from = v235;
                            v237 = _converter_v235_to_v237.to;	// L528
                            float v238;
                            union { int32_t from; float to;} _converter_v236_to_v238;
                            _converter_v236_to_v238.from = v236;
                            v238 = _converter_v236_to_v238.to;	// L529
                            float v239 = v237 + v238;	// L530
                            int32_t v240;
                            union { float from; int32_t to;} _converter_v239_to_v240;
                            _converter_v239_to_v240.from = v239;
                            v240 = _converter_v239_to_v240.to;	// L531
                            v234(31, 0) = v240;	// L532
                            int32_t v241 = v232(63, 32);	// L533
                            int32_t v242 = v233(63, 32);	// L534
                            float v243;
                            union { int32_t from; float to;} _converter_v241_to_v243;
                            _converter_v241_to_v243.from = v241;
                            v243 = _converter_v241_to_v243.to;	// L535
                            float v244;
                            union { int32_t from; float to;} _converter_v242_to_v244;
                            _converter_v242_to_v244.from = v242;
                            v244 = _converter_v242_to_v244.to;	// L536
                            float v245 = v243 + v244;	// L537
                            int32_t v246;
                            union { float from; int32_t to;} _converter_v245_to_v246;
                            _converter_v245_to_v246.from = v245;
                            v246 = _converter_v245_to_v246.to;	// L538
                            v234(63, 32) = v246;	// L539
                            int32_t v247 = v232(95, 64);	// L540
                            int32_t v248 = v233(95, 64);	// L541
                            float v249;
                            union { int32_t from; float to;} _converter_v247_to_v249;
                            _converter_v247_to_v249.from = v247;
                            v249 = _converter_v247_to_v249.to;	// L542
                            float v250;
                            union { int32_t from; float to;} _converter_v248_to_v250;
                            _converter_v248_to_v250.from = v248;
                            v250 = _converter_v248_to_v250.to;	// L543
                            float v251 = v249 + v250;	// L544
                            int32_t v252;
                            union { float from; int32_t to;} _converter_v251_to_v252;
                            _converter_v251_to_v252.from = v251;
                            v252 = _converter_v251_to_v252.to;	// L545
                            v234(95, 64) = v252;	// L546
                            int32_t v253 = v232(127, 96);	// L547
                            int32_t v254 = v233(127, 96);	// L548
                            float v255;
                            union { int32_t from; float to;} _converter_v253_to_v255;
                            _converter_v253_to_v255.from = v253;
                            v255 = _converter_v253_to_v255.to;	// L549
                            float v256;
                            union { int32_t from; float to;} _converter_v254_to_v256;
                            _converter_v254_to_v256.from = v254;
                            v256 = _converter_v254_to_v256.to;	// L550
                            float v257 = v255 + v256;	// L551
                            int32_t v258;
                            union { float from; int32_t to;} _converter_v257_to_v258;
                            _converter_v257_to_v258.from = v257;
                            v258 = _converter_v257_to_v258.to;	// L552
                            v234(127, 96) = v258;	// L553
                            ap_int<128> v259 = v234;
                            v213[(v227 + (v222 * 2))][(v228 + (v223 * 4))][(v229 + (v224 * 2))] = v259;	// L555
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
            for (int v260 = 0; v260 < 2; v260++) {	// L564
              for (int v261 = 0; v261 < 2; v261++) {	// L565
                for (int v262 = 0; v262 < 2; v262++) {	// L566
                  for (int v263 = 0; v263 < 4; v263++) {	// L567
                    for (int v264 = 0; v264 < 2; v264++) {	// L568
                      for (int v265 = 0; v265 < 2; v265++) {	// L569
                      #pragma HLS pipeline II=1
                        ap_int<128> v266 = v213[(v262 + (v260 * 2))][(v263 + (v261 * 4))][(v265 + (v264 * 2))];	// L570
                        v212.write(v266); //v212                        v212 = v266;	// L571
                        v213[(v262 + (v260 * 2))][(v263 + (v261 * 4))][(v265 + (v264 * 2))] = 0;	// L572
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

void receive2_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v267 /* v267[1] */,
  hls::stream< ap_int<128> > &v268 /* v268[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v269 /* v269[1] */,
  hls::stream< ap_int<128> > &v270 /* v270[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v271 /* v271[1] */,
  hls::stream< ap_int<128> > &v272 /* v272[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v273 /* v273[1] */,
  hls::stream< ap_int<128> > &v274 /* v274[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v267, v268);	// L587
  receive2<1>(v269, v270);	// L588
  receive2<2>(v271, v272);	// L589
  receive2<3>(v273, v274);	// L590
}

template<int NC>
void store0(
  ap_int<128> v275[8][32][16],
  hls::stream< ap_int<128> > &v276 /* v276[1] */,
  hls::stream< ap_int<128> > &v277 /* v277[1] */,
  hls::stream< ap_int<128> > &v278 /* v278[1] */,
  hls::stream< ap_int<128> > &v279 /* v279[1] */
){
  #pragma HLS inline OFF
  for (int v280 = 0; v280 < 2; v280++) {	// L595
    for (int v281 = 0; v281 < 2; v281++) {	// L596
      for (int v282 = 0; v282 < 2; v282++) {	// L597
        for (int v283 = 0; v283 < 2; v283++) {	// L598
          for (int v284 = 0; v284 < 2; v284++) {	// L599
            for (int v285 = 0; v285 < 2; v285++) {	// L600
              for (int v286 = 0; v286 < 2; v286++) {	// L601
                for (int v287 = 0; v287 < 2; v287++) {	// L602
                  for (int v288 = 0; v288 < 4; v288++) {	// L603
                    for (int v289 = 0; v289 < 2; v289++) {	// L604
                      for (int v290 = 0; v290 < 4; v290++) {	// L605
                      #pragma HLS pipeline II=1
                        bool v291 = v290 < 2;	// L606
                        ap_int<128> v292;
                        if (v291) {	// L607
                          ap_int<128> v293 = v276.read(); //v276                          v293 = v276;	// L608
                          v292 = v293;	// L609
                        } else {
                          ap_int<128> v294 = v278.read(); //v278                          v294 = v278;	// L611
                          v292 = v294;	// L612
                        }
                        v275[((v287 + (v285 * 2)) + (v280 * 4))][(((v288 + (v286 * 8)) + (v281 * 16)) + 4)][((v290 + (v289 * 4)) + (v282 * 8))] = v292;	// L614
                      }
                    }
                  }
                }
              }
            }
            for (int v295 = 0; v295 < 2; v295++) {	// L621
              for (int v296 = 0; v296 < 2; v296++) {	// L622
                for (int v297 = 0; v297 < 2; v297++) {	// L623
                  for (int v298 = 0; v298 < 4; v298++) {	// L624
                    for (int v299 = 0; v299 < 2; v299++) {	// L625
                      for (int v300 = 0; v300 < 4; v300++) {	// L626
                      #pragma HLS pipeline II=1
                        bool v301 = v300 < 2;	// L627
                        ap_int<128> v302;
                        if (v301) {	// L628
                          ap_int<128> v303 = v277.read(); //v277                          v303 = v277;	// L629
                          v302 = v303;	// L630
                        } else {
                          ap_int<128> v304 = v279.read(); //v279                          v304 = v279;	// L632
                          v302 = v304;	// L633
                        }
                        v275[((v297 + (v295 * 2)) + (v280 * 4))][((v298 + (v296 * 8)) + (v281 * 16))][((v300 + (v299 * 4)) + (v282 * 8))] = v302;	// L635
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

void store0_top(
  ap_int<128> v305[8][32][16],
  hls::stream< ap_int<128> > &v306 /* v306[1] */,
  hls::stream< ap_int<128> > &v307 /* v307[1] */,
  hls::stream< ap_int<128> > &v308 /* v308[1] */,
  hls::stream< ap_int<128> > &v309 /* v309[1] */
){
  #pragma HLS inline OFF
  store0<0>(v305, v306, v307, v308, v309);	// L650
}

template<int NC>
void load0(
  ap_int<512> v310[8][16][8],
  hls::stream< ap_int<512> > &v311 /* v311[1] */,
  hls::stream< ap_int<512> > &v312 /* v312[1] */
){
  #pragma HLS inline OFF
  for (int v313 = 0; v313 < 2; v313++) {	// L655
    for (int v314 = 0; v314 < 2; v314++) {	// L656
      for (int v315 = 0; v315 < 2; v315++) {	// L657
        for (int v316 = 0; v316 < 2; v316++) {	// L658
          for (int v317 = 0; v317 < 2; v317++) {	// L659
            for (int v318 = 0; v318 < 2; v318++) {	// L660
              for (int v319 = 0; v319 < 2; v319++) {	// L661
                for (int v320 = 0; v320 < 2; v320++) {	// L662
                  for (int v321 = 0; v321 < 4; v321++) {	// L663
                    for (int v322 = 0; v322 < 2; v322++) {	// L664
                      for (int v323 = 0; v323 < 2; v323++) {	// L665
                      #pragma HLS pipeline II=1
                        ap_int<512> v324 = v310[((v320 + (v318 * 2)) + (v313 * 4))][((v321 + (v319 * 4)) + (v316 * 8))][((v323 + (v322 * 2)) + (v317 * 4))];	// L666
                        bool v325 = v323 < 1;	// L667
                        if (v325) {	// L668
                          v311.write(v324); //v311                          v311 = v324;	// L669
                        } else {
                          v312.write(v324); //v312                          v312 = v324;	// L671
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
}

void load0_top(
  ap_int<512> v326[8][16][8],
  hls::stream< ap_int<512> > &v327 /* v327[1] */,
  hls::stream< ap_int<512> > &v328 /* v328[1] */
){
  #pragma HLS inline OFF
  load0<0>(v326, v327, v328);	// L687
}

template<int NC>
void load0_1(
  hls::stream< ap_int<512> > &v329 /* v329[1] */,
  hls::stream< ap_int<128> > &v330 /* v330[1] */
){
  #pragma HLS inline OFF
  for (int v331 = 0; v331 < 2; v331++) {	// L691
    for (int v332 = 0; v332 < 2; v332++) {	// L692
      for (int v333 = 0; v333 < 2; v333++) {	// L693
        for (int v334 = 0; v334 < 2; v334++) {	// L694
          for (int v335 = 0; v335 < 2; v335++) {	// L695
            for (int v336 = 0; v336 < 2; v336++) {	// L696
              for (int v337 = 0; v337 < 2; v337++) {	// L697
                for (int v338 = 0; v338 < 2; v338++) {	// L698
                  for (int v339 = 0; v339 < 4; v339++) {	// L699
                    for (int v340 = 0; v340 < 2; v340++) {	// L700
                      for (int v341 = 0; v341 < 1; v341++) {	// L701
                      #pragma HLS pipeline II=4
                        ap_int<512> v342 = v329.read(); //v329                        v342 = v329;	// L702
                        for (int v343 = 0; v343 < 4; v343++) {	// L703
                        #pragma HLS pipeline II=1
                          int v344 = ((v343 * 128) + 127);	// L704
                          int v345 = (v343 * 128);	// L705
                          ap_int<128> v346 = v342(v344, v345);	// L706
                          v330.write(v346); //v330                          v330 = v346;	// L707
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
}

void load0_1_top(
  hls::stream< ap_int<512> > &v347 /* v347[1] */,
  hls::stream< ap_int<128> > &v348 /* v348[1] */,
  hls::stream< ap_int<512> > &v349 /* v349[1] */,
  hls::stream< ap_int<128> > &v350 /* v350[1] */
){
  #pragma HLS inline OFF
  load0_1<0>(v347, v348);	// L723
  load0_1<1>(v349, v350);	// L724
}

template<int NC>
void load1(
  ap_int<128> v351[16][8],
  hls::stream< ap_int<128> > &v352 /* v352[1] */,
  hls::stream< ap_int<128> > &v353 /* v353[1] */
){
  #pragma HLS inline OFF
  for (int v354 = 0; v354 < 2; v354++) {	// L729
    for (int v355 = 0; v355 < 2; v355++) {	// L730
      for (int v356 = 0; v356 < 2; v356++) {	// L731
        for (int v357 = 0; v357 < 2; v357++) {	// L732
          for (int v358 = 0; v358 < 2; v358++) {	// L733
            for (int v359 = 0; v359 < 2; v359++) {	// L734
              for (int v360 = 0; v360 < 4; v360++) {	// L735
                for (int v361 = 0; v361 < 2; v361++) {	// L736
                  for (int v362 = 0; v362 < 2; v362++) {	// L737
                  #pragma HLS pipeline II=1
                    ap_int<128> v363 = v351[((v360 + (v359 * 4)) + (v357 * 8))][((v362 + (v361 * 2)) + (v355 * 4))];	// L738
                    bool v364 = v362 < 1;	// L739
                    if (v364) {	// L740
                      v352.write(v363); //v352                      v352 = v363;	// L741
                    } else {
                      v353.write(v363); //v353                      v353 = v363;	// L743
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

void load1_top(
  ap_int<128> v365[16][8],
  hls::stream< ap_int<128> > &v366 /* v366[1] */,
  hls::stream< ap_int<128> > &v367 /* v367[1] */
){
  #pragma HLS inline OFF
  load1<0>(v365, v366, v367);	// L757
}

void ttmc_pl(
  ap_int<512> v368[8][16][8],
  ap_int<128> v369[16][8],
  ap_int<128> v370[128][16],
  ap_int<128> v371[8][32][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v372 /* v372[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v373 /* v373[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v374 /* v374[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v375 /* v375[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v376 /* v376[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v377 /* v377[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v378 /* v378[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v379 /* v379[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v380 /* v380[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v381 /* v381[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v382 /* v382[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v383 /* v383[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v384 /* v384[1] */;	// L762
  hls::stream< ap_int<128> > v385 /* v385[1] */;	// L763
  hls::stream< ap_int<128> > v386 /* v386[1] */;	// L764
  hls::stream< ap_int<128> > v387 /* v387[1] */;	// L765
  hls::stream< ap_int<128> > v388 /* v388[1] */;	// L766
  hls::stream< ap_int<128> > v389 /* v389[1] */;	// L767
  hls::stream< ap_int<128> > v390 /* v390[1] */;	// L768
  hls::stream< ap_int<128> > v391 /* v391[1] */;	// L769
  hls::stream< ap_int<128> > v392 /* v392[1] */;	// L770
  hls::stream< ap_int<128> > v393 /* v393[1] */;	// L771
  hls::stream< ap_int<128> > v394 /* v394[1] */;	// L772
  hls::stream< ap_int<128> > v395 /* v395[1] */;	// L773
  ap_int<128> v396[4][8][4];	// L774
  #pragma HLS bind_storage variable=v396 type=ram_s2p impl=bram
  for (int v397 = 0; v397 < 4; v397++) {	// L775
    for (int v398 = 0; v398 < 8; v398++) {	// L776
      for (int v399 = 0; v399 < 4; v399++) {	// L777
      #pragma HLS pipeline II=1
        v396[v397][v398][v399] = 0;	// L778
      }
    }
  }
  ap_int<128> v400[4][8][4];	// L782
  #pragma HLS bind_storage variable=v400 type=ram_s2p impl=bram
  for (int v401 = 0; v401 < 4; v401++) {	// L783
    for (int v402 = 0; v402 < 8; v402++) {	// L784
      for (int v403 = 0; v403 < 4; v403++) {	// L785
      #pragma HLS pipeline II=1
        v400[v401][v402][v403] = 0;	// L786
      }
    }
  }
  ap_int<128> v404[4][8][4];	// L790
  #pragma HLS bind_storage variable=v404 type=ram_s2p impl=bram
  for (int v405 = 0; v405 < 4; v405++) {	// L791
    for (int v406 = 0; v406 < 8; v406++) {	// L792
      for (int v407 = 0; v407 < 4; v407++) {	// L793
      #pragma HLS pipeline II=1
        v404[v405][v406][v407] = 0;	// L794
      }
    }
  }
  ap_int<128> v408[4][8][4];	// L798
  #pragma HLS bind_storage variable=v408 type=ram_s2p impl=bram
  for (int v409 = 0; v409 < 4; v409++) {	// L799
    for (int v410 = 0; v410 < 8; v410++) {	// L800
      for (int v411 = 0; v411 < 4; v411++) {	// L801
      #pragma HLS pipeline II=1
        v408[v409][v410][v411] = 0;	// L802
      }
    }
  }
  hls::stream< ap_int<512> > v412 /* v412[1] */;	// L806
  #pragma HLS stream variable=v412 depth=1
  hls::stream< ap_int<512> > v413 /* v413[1] */;	// L807
  #pragma HLS stream variable=v413 depth=1
  send3_top(v375, v392, v372, v395);	// L808
  load2_top(v370, v393, v390, v391, v389);	// L809
  send5_top(v376, v390, v383, v389, v379, v391, v377, v393);	// L810
  send1_top(v380, v394, v381, v388);	// L811
  receive2_top(v382, v386, v378, v384, v373, v387, v374, v385);	// L812
  store0_top(v371, v386, v384, v387, v385);	// L813
  load0_top(v368, v413, v412);	// L814
  load0_1_top(v413, v395, v412, v392);	// L815
  load1_top(v369, v394, v388);	// L816
}

void top(
  ap_int<512> v414[8][16][8],
  ap_int<128> v415[16][8],
  ap_int<128> v416[128][16],
  ap_int<128> v417[8][32][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v418 /* v418[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v419 /* v419[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v420 /* v420[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v421 /* v421[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v422 /* v422[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v423 /* v423[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v424 /* v424[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v425 /* v425[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v426 /* v426[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v427 /* v427[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v428 /* v428[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v429 /* v429[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v414
  #pragma HLS interface s_axilite bundle=control port=v414
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v415
  #pragma HLS interface s_axilite bundle=control port=v415
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v416
  #pragma HLS interface s_axilite bundle=control port=v416
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v417
  #pragma HLS interface s_axilite bundle=control port=v417
  #pragma HLS interface axis port=v418
  #pragma HLS interface axis port=v419
  #pragma HLS interface axis port=v420
  #pragma HLS interface axis port=v421
  #pragma HLS interface axis port=v422
  #pragma HLS interface axis port=v423
  #pragma HLS interface axis port=v424
  #pragma HLS interface axis port=v425
  #pragma HLS interface axis port=v426
  #pragma HLS interface axis port=v427
  #pragma HLS interface axis port=v428
  #pragma HLS interface axis port=v429

  ttmc_pl(v414, v415, v416, v417, v418, v419, v420, v421, v422, v423, v424, v425, v426, v427, v428, v429);	// L855
}


