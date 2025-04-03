
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
  hls::stream< ap_int<128> > &v122 /* v122[1] */,
  hls::stream< ap_int<512> > &v123 /* v123[1] */
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
                  ap_int<512> v132 = v123.read(); //v123                  v132 = v123;	// L324
                  for (int v133 = 0; v133 < 4; v133++) {	// L325
                  #pragma HLS pipeline II=1
                    int v134 = ((v133 * 128) + 127);	// L326
                    int v135 = (v133 * 128);	// L327
                    ap_int<128> v136 = v132(v134, v135);	// L328
                    v122.write(v136); //v122                    v122 = v136;	// L329
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
  hls::stream< ap_int<128> > &v137 /* v137[1] */,
  hls::stream< ap_int<512> > &v138 /* v138[1] */,
  hls::stream< ap_int<128> > &v139 /* v139[1] */,
  hls::stream< ap_int<512> > &v140 /* v140[1] */,
  hls::stream< ap_int<128> > &v141 /* v141[1] */,
  hls::stream< ap_int<512> > &v142 /* v142[1] */,
  hls::stream< ap_int<128> > &v143 /* v143[1] */,
  hls::stream< ap_int<512> > &v144 /* v144[1] */
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
                      int32_t v206 = v204 + v205;	// L455
                      v203(31, 0) = v206;	// L456
                      int32_t v207 = v201(63, 32);	// L457
                      int32_t v208 = v202(63, 32);	// L458
                      int32_t v209 = v207 + v208;	// L459
                      v203(63, 32) = v209;	// L460
                      int32_t v210 = v201(95, 64);	// L461
                      int32_t v211 = v202(95, 64);	// L462
                      int32_t v212 = v210 + v211;	// L463
                      v203(95, 64) = v212;	// L464
                      int32_t v213 = v201(127, 96);	// L465
                      int32_t v214 = v202(127, 96);	// L466
                      int32_t v215 = v213 + v214;	// L467
                      v203(127, 96) = v215;	// L468
                      ap_int<128> v216 = v203;
                      v186[(v197 + (v193 * 2))][(v198 + (v194 * 4))] = v216;	// L470
                    }
                  }
                }
              }
            }
          }
        }
      }
      for (int v217 = 0; v217 < 2; v217++) {	// L479
        for (int v218 = 0; v218 < 2; v218++) {	// L480
          for (int v219 = 0; v219 < 2; v219++) {	// L481
            for (int v220 = 0; v220 < 4; v220++) {	// L482
            #pragma HLS pipeline II=1
              ap_int<128> v221 = v186[(v218 + (v217 * 2))][(v220 + (v219 * 4))];	// L483
              v185.write(v221); //v185              v185 = v221;	// L484
              v186[(v218 + (v217 * 2))][(v220 + (v219 * 4))] = 0;	// L485
            }
          }
        }
      }
    }
  }
}

void receive2_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v222 /* v222[1] */,
  hls::stream< ap_int<128> > &v223 /* v223[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v224 /* v224[1] */,
  hls::stream< ap_int<128> > &v225 /* v225[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v226 /* v226[1] */,
  hls::stream< ap_int<128> > &v227 /* v227[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v228 /* v228[1] */,
  hls::stream< ap_int<128> > &v229 /* v229[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v222, v223);	// L495
  receive2<1>(v224, v225);	// L496
  receive2<2>(v226, v227);	// L497
  receive2<3>(v228, v229);	// L498
}

void send6_0(
  hls::stream< ap_int<128> > &v230 /* v230[1] */,
  ap_int<128> v231[32][8],
  bool v232
){
  #pragma HLS inline OFF
  if (v232) {	// L502
    for (int v233 = 0; v233 < 2; v233++) {	// L503
      for (int v234 = 0; v234 < 16; v234++) {	// L504
        for (int v235 = 0; v235 < 2; v235++) {	// L505
          for (int v236 = 0; v236 < 4; v236++) {	// L506
          #pragma HLS pipeline II=1
            ap_int<128> v237 = v230.read(); //v230            v237 = v230;	// L507
            v231[(v234 + (v233 * 16))][(v236 + (v235 * 4))] = v237;	// L508
          }
        }
      }
    }
  }
}

void send6_1(
  ap_int<128> v238[32][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v239 /* v239[1] */,
  bool v240
){
  #pragma HLS inline OFF
  if (v240) {	// L517
    for (int v241 = 0; v241 < 2; v241++) {	// L518
      for (int v242 = 0; v242 < 2; v242++) {	// L519
        for (int v243 = 0; v243 < 2; v243++) {	// L520
          for (int v244 = 0; v244 < 2; v244++) {	// L521
            for (int v245 = 0; v245 < 16; v245++) {	// L522
              for (int v246 = 0; v246 < 4; v246++) {	// L523
              #pragma HLS pipeline II=1
                ap_int<128> v247 = v238[(v245 + (v244 * 16))][(v246 + (v242 * 4))];	// L524
                ap_axiu<128, 0 ,0 ,0> v239_axiu;
                v239_axiu.data = v247;
                v239_axiu.keep = -1;
                v239.write(v239_axiu); //v239                v239 = v247;	// L525
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
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v248 /* v248[1] */,
  hls::stream< ap_int<128> > &v249 /* v249[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v250[32][8];	// L541
  #pragma HLS bind_storage variable=v250 type=ram_t2p impl=uram
  ap_int<128> v251[32][8];	// L542
  #pragma HLS bind_storage variable=v251 type=ram_t2p impl=uram
  for (int v252 = 0; v252 < 1; v252++) {	// L543
    for (int v253 = 0; v253 < 2; v253++) {	// L544
      for (int v254 = 0; v254 < 2; v254++) {	// L545
        for (int v255 = 0; v255 < 2; v255++) {	// L546
          int v256 = v254 * 2;	// L547
          int v257 = v255 + v256;	// L548
          int v258 = v253 * 4;	// L549
          int v259 = v257 + v258;	// L550
          int v260 = v252 * 8;	// L551
          int v261 = v259 + v260;	// L552
          int v262 = v261 % 2;	// L553
          bool v263 = v262 == 0;	// L554
          bool v264 = v261 != 0;	// L555
          if (v263) {	// L556
            send6_0(v249, v250, 1);	// L557
            send6_1(v251, v248, v264);	// L558
          } else {
            send6_0(v249, v251, 1);	// L560
            send6_1(v250, v248, v264);	// L561
          }
        }
      }
    }
  }
  send6_1(v251, v248, 1);	// L567
}

void send6_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v265 /* v265[1] */,
  hls::stream< ap_int<128> > &v266 /* v266[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v267 /* v267[1] */,
  hls::stream< ap_int<128> > &v268 /* v268[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v269 /* v269[1] */,
  hls::stream< ap_int<128> > &v270 /* v270[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v271 /* v271[1] */,
  hls::stream< ap_int<128> > &v272 /* v272[1] */
){
  #pragma HLS inline OFF
  send6<0>(v265, v266);	// L571
  send6<1>(v267, v268);	// L572
  send6<2>(v269, v270);	// L573
  send6<3>(v271, v272);	// L574
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v273 /* v273[1] */,
  hls::stream< ap_int<512> > &v274 /* v274[1] */
){
  #pragma HLS inline OFF
  for (int v275 = 0; v275 < 1; v275++) {	// L579
    for (int v276 = 0; v276 < 2; v276++) {	// L580
      for (int v277 = 0; v277 < 2; v277++) {	// L581
        for (int v278 = 0; v278 < 2; v278++) {	// L582
          for (int v279 = 0; v279 < 2; v279++) {	// L583
            for (int v280 = 0; v280 < 1; v280++) {	// L584
            #pragma HLS pipeline II=4
              ap_int<512> v281 = 0;
              for (int v282 = 0; v282 < 4; v282++) {	// L586
              #pragma HLS pipeline II=1
                ap_int<128> v283 = v273.read(); //v273                v283 = v273;	// L587
                int v284 = ((v282 * 128) + 127);	// L588
                int v285 = (v282 * 128);	// L589
                v281(v284, v285) = v283;	// L590
              }
              v274.write(v281); //v274              v274 = v281;	// L592
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v286 /* v286[1] */,
  hls::stream< ap_int<512> > &v287 /* v287[1] */,
  hls::stream< ap_int<128> > &v288 /* v288[1] */,
  hls::stream< ap_int<512> > &v289 /* v289[1] */,
  hls::stream< ap_int<128> > &v290 /* v290[1] */,
  hls::stream< ap_int<512> > &v291 /* v291[1] */,
  hls::stream< ap_int<128> > &v292 /* v292[1] */,
  hls::stream< ap_int<512> > &v293 /* v293[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v286, v287);	// L602
  store0_0<1>(v288, v289);	// L603
  store0_0<2>(v290, v291);	// L604
  store0_0<3>(v292, v293);	// L605
}

template<int NC>
void store0(
  ap_int<512> v294[8][8],
  hls::stream< ap_int<512> > &v295 /* v295[1] */,
  hls::stream< ap_int<512> > &v296 /* v296[1] */,
  hls::stream< ap_int<512> > &v297 /* v297[1] */,
  hls::stream< ap_int<512> > &v298 /* v298[1] */
){
  #pragma HLS inline OFF
  for (int v299 = 0; v299 < 1; v299++) {	// L610
    for (int v300 = 0; v300 < 2; v300++) {	// L611
      for (int v301 = 0; v301 < 2; v301++) {	// L612
        for (int v302 = 0; v302 < 2; v302++) {	// L613
          for (int v303 = 0; v303 < 2; v303++) {	// L614
            for (int v304 = 0; v304 < 2; v304++) {	// L615
            #pragma HLS pipeline II=1
              bool v305 = v304 < 1;	// L616
              ap_int<512> v306;
              if (v305) {	// L617
                ap_int<512> v307 = v298.read(); //v298                v307 = v298;	// L618
                v306 = v307;	// L619
              } else {
                ap_int<512> v308 = v297.read(); //v297                v308 = v297;	// L621
                v306 = v308;	// L622
              }
              v294[((v302 + (v301 * 4)) + (v299 * 8))][((v304 + (v303 * 2)) + (v300 * 4))] = v306;	// L624
            }
          }
        }
      }
      for (int v309 = 0; v309 < 2; v309++) {	// L629
        for (int v310 = 0; v310 < 2; v310++) {	// L630
          for (int v311 = 0; v311 < 2; v311++) {	// L631
            for (int v312 = 0; v312 < 2; v312++) {	// L632
            #pragma HLS pipeline II=1
              bool v313 = v312 < 1;	// L633
              ap_int<512> v314;
              if (v313) {	// L634
                ap_int<512> v315 = v296.read(); //v296                v315 = v296;	// L635
                v314 = v315;	// L636
              } else {
                ap_int<512> v316 = v295.read(); //v295                v316 = v295;	// L638
                v314 = v316;	// L639
              }
              v294[(((v310 + (v309 * 4)) + (v299 * 8)) + 2)][((v312 + (v311 * 2)) + (v300 * 4))] = v314;	// L641
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v317[8][8],
  hls::stream< ap_int<512> > &v318 /* v318[1] */,
  hls::stream< ap_int<512> > &v319 /* v319[1] */,
  hls::stream< ap_int<512> > &v320 /* v320[1] */,
  hls::stream< ap_int<512> > &v321 /* v321[1] */
){
  #pragma HLS inline OFF
  store0<0>(v317, v318, v319, v320, v321);	// L651
}

template<int NC>
void load0(
  ap_int<512> v322[8][32][8],
  hls::stream< ap_int<512> > &v323 /* v323[1] */,
  hls::stream< ap_int<512> > &v324 /* v324[1] */,
  hls::stream< ap_int<512> > &v325 /* v325[1] */,
  hls::stream< ap_int<512> > &v326 /* v326[1] */
){
  #pragma HLS inline OFF
  for (int v327 = 0; v327 < 1; v327++) {	// L656
    for (int v328 = 0; v328 < 2; v328++) {	// L657
      for (int v329 = 0; v329 < 2; v329++) {	// L658
        for (int v330 = 0; v330 < 2; v330++) {	// L659
          for (int v331 = 0; v331 < 2; v331++) {	// L660
            for (int v332 = 0; v332 < 2; v332++) {	// L661
              for (int v333 = 0; v333 < 2; v333++) {	// L662
                for (int v334 = 0; v334 < 8; v334++) {	// L663
                  for (int v335 = 0; v335 < 2; v335++) {	// L664
                    for (int v336 = 0; v336 < 2; v336++) {	// L665
                    #pragma HLS pipeline II=1
                      ap_int<512> v337 = v322[((v333 + (v331 * 4)) + (v327 * 8))][((v334 + (v332 * 8)) + (v329 * 16))][((v336 + (v335 * 2)) + (v330 * 4))];	// L666
                      bool v338 = v336 < 1;	// L667
                      if (v338) {	// L668
                        v326.write(v337); //v326                        v326 = v337;	// L669
                      } else {
                        v325.write(v337); //v325                        v325 = v337;	// L671
                      }
                    }
                  }
                }
              }
            }
          }
          for (int v339 = 0; v339 < 2; v339++) {	// L679
            for (int v340 = 0; v340 < 2; v340++) {	// L680
              for (int v341 = 0; v341 < 2; v341++) {	// L681
                for (int v342 = 0; v342 < 8; v342++) {	// L682
                  for (int v343 = 0; v343 < 2; v343++) {	// L683
                    for (int v344 = 0; v344 < 2; v344++) {	// L684
                    #pragma HLS pipeline II=1
                      ap_int<512> v345 = v322[(((v341 + (v339 * 4)) + (v327 * 8)) + 2)][((v342 + (v340 * 8)) + (v329 * 16))][((v344 + (v343 * 2)) + (v330 * 4))];	// L685
                      bool v346 = v344 < 1;	// L686
                      if (v346) {	// L687
                        v324.write(v345); //v324                        v324 = v345;	// L688
                      } else {
                        v323.write(v345); //v323                        v323 = v345;	// L690
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
  ap_int<512> v347[8][32][8],
  hls::stream< ap_int<512> > &v348 /* v348[1] */,
  hls::stream< ap_int<512> > &v349 /* v349[1] */,
  hls::stream< ap_int<512> > &v350 /* v350[1] */,
  hls::stream< ap_int<512> > &v351 /* v351[1] */
){
  #pragma HLS inline OFF
  load0<0>(v347, v348, v349, v350, v351);	// L705
}

template<int NC>
void load0_3(
  hls::stream< ap_int<128> > &v352 /* v352[1] */,
  hls::stream< ap_int<512> > &v353 /* v353[1] */
){
  #pragma HLS inline OFF
  for (int v354 = 0; v354 < 1; v354++) {	// L709
    for (int v355 = 0; v355 < 2; v355++) {	// L710
      for (int v356 = 0; v356 < 2; v356++) {	// L711
        for (int v357 = 0; v357 < 2; v357++) {	// L712
          for (int v358 = 0; v358 < 2; v358++) {	// L713
            for (int v359 = 0; v359 < 2; v359++) {	// L714
              for (int v360 = 0; v360 < 2; v360++) {	// L715
                for (int v361 = 0; v361 < 8; v361++) {	// L716
                  for (int v362 = 0; v362 < 2; v362++) {	// L717
                    for (int v363 = 0; v363 < 1; v363++) {	// L718
                    #pragma HLS pipeline II=4
                      ap_int<512> v364 = v353.read(); //v353                      v364 = v353;	// L719
                      for (int v365 = 0; v365 < 4; v365++) {	// L720
                      #pragma HLS pipeline II=1
                        int v366 = ((v365 * 128) + 127);	// L721
                        int v367 = (v365 * 128);	// L722
                        ap_int<128> v368 = v364(v366, v367);	// L723
                        v352.write(v368); //v352                        v352 = v368;	// L724
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
  hls::stream< ap_int<128> > &v369 /* v369[1] */,
  hls::stream< ap_int<512> > &v370 /* v370[1] */,
  hls::stream< ap_int<128> > &v371 /* v371[1] */,
  hls::stream< ap_int<512> > &v372 /* v372[1] */,
  hls::stream< ap_int<128> > &v373 /* v373[1] */,
  hls::stream< ap_int<512> > &v374 /* v374[1] */,
  hls::stream< ap_int<128> > &v375 /* v375[1] */,
  hls::stream< ap_int<512> > &v376 /* v376[1] */
){
  #pragma HLS inline OFF
  load0_3<0>(v369, v370);	// L739
  load0_3<1>(v371, v372);	// L740
  load0_3<2>(v373, v374);	// L741
  load0_3<3>(v375, v376);	// L742
}

template<int NC>
void load1(
  ap_int<512> v377[32][8],
  hls::stream< ap_int<512> > &v378 /* v378[1] */,
  hls::stream< ap_int<512> > &v379 /* v379[1] */
){
  #pragma HLS inline OFF
  for (int v380 = 0; v380 < 1; v380++) {	// L747
    for (int v381 = 0; v381 < 2; v381++) {	// L748
      for (int v382 = 0; v382 < 2; v382++) {	// L749
        for (int v383 = 0; v383 < 2; v383++) {	// L750
          for (int v384 = 0; v384 < 2; v384++) {	// L751
            for (int v385 = 0; v385 < 8; v385++) {	// L752
              for (int v386 = 0; v386 < 2; v386++) {	// L753
                for (int v387 = 0; v387 < 2; v387++) {	// L754
                #pragma HLS pipeline II=1
                  ap_int<512> v388 = v377[((v385 + (v384 * 8)) + (v382 * 16))][((v387 + (v386 * 2)) + (v381 * 4))];	// L755
                  bool v389 = v387 < 1;	// L756
                  if (v389) {	// L757
                    v379.write(v388); //v379                    v379 = v388;	// L758
                  } else {
                    v378.write(v388); //v378                    v378 = v388;	// L760
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
  ap_int<512> v390[32][8],
  hls::stream< ap_int<512> > &v391 /* v391[1] */,
  hls::stream< ap_int<512> > &v392 /* v392[1] */
){
  #pragma HLS inline OFF
  load1<0>(v390, v391, v392);	// L773
}

template<int NC>
void load1_1(
  hls::stream< ap_int<128> > &v393 /* v393[1] */,
  hls::stream< ap_int<512> > &v394 /* v394[1] */
){
  #pragma HLS inline OFF
  for (int v395 = 0; v395 < 1; v395++) {	// L777
    for (int v396 = 0; v396 < 2; v396++) {	// L778
      for (int v397 = 0; v397 < 2; v397++) {	// L779
        for (int v398 = 0; v398 < 2; v398++) {	// L780
          for (int v399 = 0; v399 < 2; v399++) {	// L781
            for (int v400 = 0; v400 < 8; v400++) {	// L782
              for (int v401 = 0; v401 < 2; v401++) {	// L783
                for (int v402 = 0; v402 < 1; v402++) {	// L784
                #pragma HLS pipeline II=4
                  ap_int<512> v403 = v394.read(); //v394                  v403 = v394;	// L785
                  for (int v404 = 0; v404 < 4; v404++) {	// L786
                  #pragma HLS pipeline II=1
                    int v405 = ((v404 * 128) + 127);	// L787
                    int v406 = (v404 * 128);	// L788
                    ap_int<128> v407 = v403(v405, v406);	// L789
                    v393.write(v407); //v393                    v393 = v407;	// L790
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
  hls::stream< ap_int<128> > &v408 /* v408[1] */,
  hls::stream< ap_int<512> > &v409 /* v409[1] */,
  hls::stream< ap_int<128> > &v410 /* v410[1] */,
  hls::stream< ap_int<512> > &v411 /* v411[1] */
){
  #pragma HLS inline OFF
  load1_1<0>(v408, v409);	// L803
  load1_1<1>(v410, v411);	// L804
}

void mttkrp_pl(
  ap_int<512> v412[8][32][8],
  ap_int<512> v413[32][8],
  ap_int<512> v414[128][8],
  ap_int<512> v415[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v416 /* v416[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v417 /* v417[1] */,
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
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v430 /* v430[1] */;	// L808
  hls::stream< ap_int<128> > v431 /* v431[1] */;	// L809
  hls::stream< ap_int<128> > v432 /* v432[1] */;	// L810
  hls::stream< ap_int<128> > v433 /* v433[1] */;	// L811
  hls::stream< ap_int<128> > v434 /* v434[1] */;	// L812
  hls::stream< ap_int<128> > v435 /* v435[1] */;	// L813
  hls::stream< ap_int<128> > v436 /* v436[1] */;	// L814
  hls::stream< ap_int<128> > v437 /* v437[1] */;	// L815
  hls::stream< ap_int<128> > v438 /* v438[1] */;	// L816
  hls::stream< ap_int<128> > v439 /* v439[1] */;	// L817
  hls::stream< ap_int<128> > v440 /* v440[1] */;	// L818
  hls::stream< ap_int<128> > v441 /* v441[1] */;	// L819
  hls::stream< ap_int<128> > v442 /* v442[1] */;	// L820
  hls::stream< ap_int<128> > v443 /* v443[1] */;	// L821
  hls::stream< ap_int<512> > v444 /* v444[1] */;	// L822
  #pragma HLS stream variable=v444 depth=1
  hls::stream< ap_int<512> > v445 /* v445[1] */;	// L823
  #pragma HLS stream variable=v445 depth=1
  hls::stream< ap_int<512> > v446 /* v446[1] */;	// L824
  #pragma HLS stream variable=v446 depth=1
  hls::stream< ap_int<512> > v447 /* v447[1] */;	// L825
  #pragma HLS stream variable=v447 depth=1
  hls::stream< ap_int<512> > v448 /* v448[1] */;	// L826
  #pragma HLS stream variable=v448 depth=1
  hls::stream< ap_int<512> > v449 /* v449[1] */;	// L827
  #pragma HLS stream variable=v449 depth=1
  hls::stream< ap_int<512> > v450 /* v450[1] */;	// L828
  #pragma HLS stream variable=v450 depth=1
  hls::stream< ap_int<512> > v451 /* v451[1] */;	// L829
  #pragma HLS stream variable=v451 depth=1
  hls::stream< ap_int<512> > v452 /* v452[1] */;	// L830
  #pragma HLS stream variable=v452 depth=1
  hls::stream< ap_int<512> > v453 /* v453[1] */;	// L831
  #pragma HLS stream variable=v453 depth=1
  hls::stream< ap_int<512> > v454 /* v454[1] */;	// L832
  #pragma HLS stream variable=v454 depth=1
  hls::stream< ap_int<512> > v455 /* v455[1] */;	// L833
  #pragma HLS stream variable=v455 depth=1
  hls::stream< ap_int<512> > v456 /* v456[1] */;	// L834
  #pragma HLS stream variable=v456 depth=1
  hls::stream< ap_int<512> > v457 /* v457[1] */;	// L835
  #pragma HLS stream variable=v457 depth=1
  send3_top(v426, v440, v419, v435, v418, v434, v429, v443);	// L836
  load2_top(v414, v444, v445, v446, v447);	// L837
  load2_3_top(v441, v447, v439, v446, v437, v445, v436, v444);	// L838
  send5_top(v423, v438, v428, v442);	// L839
  receive2_top(v417, v432, v424, v430, v416, v433, v420, v431);	// L840
  send6_top(v422, v437, v425, v439, v421, v436, v427, v441);	// L841
  store0_0_top(v433, v448, v432, v449, v431, v450, v430, v451);	// L842
  store0_top(v415, v448, v449, v450, v451);	// L843
  load0_top(v412, v452, v453, v454, v455);	// L844
  load0_3_top(v443, v455, v440, v454, v435, v453, v434, v452);	// L845
  load1_top(v413, v456, v457);	// L846
  load1_1_top(v442, v457, v438, v456);	// L847
}

void top(
  ap_int<512> v458[8][32][8],
  ap_int<512> v459[32][8],
  ap_int<512> v460[128][8],
  ap_int<512> v461[8][8],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v462 /* v462[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v463 /* v463[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v464 /* v464[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v465 /* v465[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v466 /* v466[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v467 /* v467[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v468 /* v468[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v469 /* v469[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v470 /* v470[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v471 /* v471[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v472 /* v472[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v473 /* v473[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v474 /* v474[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v475 /* v475[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v458
  #pragma HLS interface s_axilite bundle=control port=v458
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v459
  #pragma HLS interface s_axilite bundle=control port=v459
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v460
  #pragma HLS interface s_axilite bundle=control port=v460
  #pragma HLS interface m_axi offset=slave bundle=gmem3 port=v461
  #pragma HLS interface s_axilite bundle=control port=v461
  #pragma HLS interface axis port=v462
  #pragma HLS interface axis port=v463
  #pragma HLS interface axis port=v464
  #pragma HLS interface axis port=v465
  #pragma HLS interface axis port=v466
  #pragma HLS interface axis port=v467
  #pragma HLS interface axis port=v468
  #pragma HLS interface axis port=v469
  #pragma HLS interface axis port=v470
  #pragma HLS interface axis port=v471
  #pragma HLS interface axis port=v472
  #pragma HLS interface axis port=v473
  #pragma HLS interface axis port=v474
  #pragma HLS interface axis port=v475

  mttkrp_pl(v458, v459, v460, v461, v462, v463, v464, v465, v466, v467, v468, v469, v470, v471, v472, v473, v474, v475);	// L890
}


