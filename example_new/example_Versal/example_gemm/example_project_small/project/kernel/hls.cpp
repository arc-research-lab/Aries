
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
  hls::stream< ap_int<128> > &v40 /* v40[1] */,
  ap_int<128> v41[64][16],
  bool v42
){
  #pragma HLS inline OFF
  if (v42) {	// L153
    for (int v43 = 0; v43 < 2; v43++) {	// L154
      for (int v44 = 0; v44 < 32; v44++) {	// L155
        for (int v45 = 0; v45 < 2; v45++) {	// L156
          for (int v46 = 0; v46 < 8; v46++) {	// L157
          #pragma HLS pipeline II=1
            ap_int<128> v47 = v40.read(); //v40            v47 = v40;	// L158
            v41[(v44 + (v43 * 32))][(v46 + (v45 * 8))] = v47;	// L159
          }
        }
      }
    }
  }
}

void send3_1(
  ap_int<128> v48[64][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v49 /* v49[1] */,
  bool v50
){
  #pragma HLS inline OFF
  if (v50) {	// L168
    for (int v51 = 0; v51 < 2; v51++) {	// L169
      for (int v52 = 0; v52 < 2; v52++) {	// L170
        for (int v53 = 0; v53 < 2; v53++) {	// L171
          for (int v54 = 0; v54 < 32; v54++) {	// L172
            for (int v55 = 0; v55 < 8; v55++) {	// L173
            #pragma HLS pipeline II=1
              ap_int<128> v56 = v48[(v54 + (v53 * 32))][(v55 + (v52 * 8))];	// L174
              ap_axiu<128, 0 ,0 ,0> v49_axiu;
              v49_axiu.data = v56;
              v49_axiu.keep = -1;
              v49.write(v49_axiu); //v49              v49 = v56;	// L175
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send3(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v57 /* v57[1] */,
  hls::stream< ap_int<128> > &v58 /* v58[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v59[64][16];	// L189
  #pragma HLS bind_storage variable=v59 type=ram_s2p impl=bram
  ap_int<128> v60[64][16];	// L190
  #pragma HLS bind_storage variable=v60 type=ram_s2p impl=bram
  for (int v61 = 0; v61 < 2; v61++) {	// L191
    for (int v62 = 0; v62 < 2; v62++) {	// L192
      for (int v63 = 0; v63 < 2; v63++) {	// L193
        int v64 = v62 * 2;	// L194
        int v65 = v63 + v64;	// L195
        int v66 = v61 * 4;	// L196
        int v67 = v65 + v66;	// L197
        int v68 = v67 % 2;	// L198
        bool v69 = v68 == 0;	// L199
        bool v70 = v67 != 0;	// L200
        if (v69) {	// L201
          send3_0(v58, v59, 1);	// L202
          send3_1(v60, v57, v70);	// L203
        } else {
          send3_0(v58, v60, 1);	// L205
          send3_1(v59, v57, v70);	// L206
        }
      }
    }
  }
  send3_1(v60, v57, 1);	// L211
}

void send3_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v71 /* v71[1] */,
  hls::stream< ap_int<128> > &v72 /* v72[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v73 /* v73[1] */,
  hls::stream< ap_int<128> > &v74 /* v74[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v75 /* v75[1] */,
  hls::stream< ap_int<128> > &v76 /* v76[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v77 /* v77[1] */,
  hls::stream< ap_int<128> > &v78 /* v78[1] */
){
  #pragma HLS inline OFF
  send3<0>(v71, v72);	// L215
  send3<1>(v73, v74);	// L216
  send3<2>(v75, v76);	// L217
  send3<3>(v77, v78);	// L218
}

template<int NC>
void receive2(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v79 /* v79[1] */,
  hls::stream< ap_int<128> > &v80 /* v80[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v81[64][16];	// L231
  #pragma HLS bind_storage variable=v81 type=ram_t2p impl=uram
  for (int v82 = 0; v82 < 64; v82++) {	// L232
    for (int v83 = 0; v83 < 16; v83++) {	// L233
    #pragma HLS pipeline II=1
      v81[v82][v83] = 0;	// L234
    }
  }
  for (int v84 = 0; v84 < 2; v84++) {	// L237
    for (int v85 = 0; v85 < 2; v85++) {	// L238
      for (int v86 = 0; v86 < 2; v86++) {	// L239
        for (int v87 = 0; v87 < 2; v87++) {	// L240
          for (int v88 = 0; v88 < 2; v88++) {	// L241
            for (int v89 = 0; v89 < 2; v89++) {	// L242
              for (int v90 = 0; v90 < 32; v90++) {	// L243
                for (int v91 = 0; v91 < 8; v91++) {	// L244
                #pragma HLS pipeline II=1
                  ap_axiu<128, 0 ,0 ,0> v79_axiu = v79.read();
                  ap_int<128> v92 = v79_axiu.data; //v79                  v92 = v79;	// L245
                  ap_int<128> v93 = v81[(v90 + (v87 * 32))][(v91 + (v88 * 8))];	// L246
                  ap_int<128> v94 = v92;
                  ap_int<128> v95 = v93;
                  ap_int<128> v96 = 0;
                  int32_t v97 = v94(31, 0);	// L250
                  int32_t v98 = v95(31, 0);	// L251
                  float v99;
                  union { int32_t from; float to;} _converter_v97_to_v99;
                  _converter_v97_to_v99.from = v97;
                  v99 = _converter_v97_to_v99.to;	// L252
                  float v100;
                  union { int32_t from; float to;} _converter_v98_to_v100;
                  _converter_v98_to_v100.from = v98;
                  v100 = _converter_v98_to_v100.to;	// L253
                  float v101 = v99 + v100;	// L254
                  int32_t v102;
                  union { float from; int32_t to;} _converter_v101_to_v102;
                  _converter_v101_to_v102.from = v101;
                  v102 = _converter_v101_to_v102.to;	// L255
                  v96(31, 0) = v102;	// L256
                  int32_t v103 = v94(63, 32);	// L257
                  int32_t v104 = v95(63, 32);	// L258
                  float v105;
                  union { int32_t from; float to;} _converter_v103_to_v105;
                  _converter_v103_to_v105.from = v103;
                  v105 = _converter_v103_to_v105.to;	// L259
                  float v106;
                  union { int32_t from; float to;} _converter_v104_to_v106;
                  _converter_v104_to_v106.from = v104;
                  v106 = _converter_v104_to_v106.to;	// L260
                  float v107 = v105 + v106;	// L261
                  int32_t v108;
                  union { float from; int32_t to;} _converter_v107_to_v108;
                  _converter_v107_to_v108.from = v107;
                  v108 = _converter_v107_to_v108.to;	// L262
                  v96(63, 32) = v108;	// L263
                  int32_t v109 = v94(95, 64);	// L264
                  int32_t v110 = v95(95, 64);	// L265
                  float v111;
                  union { int32_t from; float to;} _converter_v109_to_v111;
                  _converter_v109_to_v111.from = v109;
                  v111 = _converter_v109_to_v111.to;	// L266
                  float v112;
                  union { int32_t from; float to;} _converter_v110_to_v112;
                  _converter_v110_to_v112.from = v110;
                  v112 = _converter_v110_to_v112.to;	// L267
                  float v113 = v111 + v112;	// L268
                  int32_t v114;
                  union { float from; int32_t to;} _converter_v113_to_v114;
                  _converter_v113_to_v114.from = v113;
                  v114 = _converter_v113_to_v114.to;	// L269
                  v96(95, 64) = v114;	// L270
                  int32_t v115 = v94(127, 96);	// L271
                  int32_t v116 = v95(127, 96);	// L272
                  float v117;
                  union { int32_t from; float to;} _converter_v115_to_v117;
                  _converter_v115_to_v117.from = v115;
                  v117 = _converter_v115_to_v117.to;	// L273
                  float v118;
                  union { int32_t from; float to;} _converter_v116_to_v118;
                  _converter_v116_to_v118.from = v116;
                  v118 = _converter_v116_to_v118.to;	// L274
                  float v119 = v117 + v118;	// L275
                  int32_t v120;
                  union { float from; int32_t to;} _converter_v119_to_v120;
                  _converter_v119_to_v120.from = v119;
                  v120 = _converter_v119_to_v120.to;	// L276
                  v96(127, 96) = v120;	// L277
                  ap_int<128> v121 = v96;
                  v81[(v90 + (v87 * 32))][(v91 + (v88 * 8))] = v121;	// L279
                }
              }
            }
          }
        }
        for (int v122 = 0; v122 < 2; v122++) {	// L285
          for (int v123 = 0; v123 < 32; v123++) {	// L286
            for (int v124 = 0; v124 < 2; v124++) {	// L287
              for (int v125 = 0; v125 < 8; v125++) {	// L288
              #pragma HLS pipeline II=1
                ap_int<128> v126 = v81[(v123 + (v122 * 32))][(v125 + (v124 * 8))];	// L289
                v80.write(v126); //v80                v80 = v126;	// L290
                v81[(v123 + (v122 * 32))][(v125 + (v124 * 8))] = 0;	// L291
              }
            }
          }
        }
      }
    }
  }
}

void receive2_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v127 /* v127[1] */,
  hls::stream< ap_int<128> > &v128 /* v128[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v129 /* v129[1] */,
  hls::stream< ap_int<128> > &v130 /* v130[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v131 /* v131[1] */,
  hls::stream< ap_int<128> > &v132 /* v132[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v133 /* v133[1] */,
  hls::stream< ap_int<128> > &v134 /* v134[1] */
){
  #pragma HLS inline OFF
  receive2<0>(v127, v128);	// L302
  receive2<1>(v129, v130);	// L303
  receive2<2>(v131, v132);	// L304
  receive2<3>(v133, v134);	// L305
}

void send6_0(
  hls::stream< ap_int<128> > &v135 /* v135[1] */,
  ap_int<128> v136[64][16],
  bool v137
){
  #pragma HLS inline OFF
  if (v137) {	// L309
    for (int v138 = 0; v138 < 2; v138++) {	// L310
      for (int v139 = 0; v139 < 32; v139++) {	// L311
        for (int v140 = 0; v140 < 2; v140++) {	// L312
          for (int v141 = 0; v141 < 8; v141++) {	// L313
          #pragma HLS pipeline II=1
            ap_int<128> v142 = v135.read(); //v135            v142 = v135;	// L314
            v136[(v139 + (v138 * 32))][(v141 + (v140 * 8))] = v142;	// L315
          }
        }
      }
    }
  }
}

void send6_1(
  ap_int<128> v143[64][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v144 /* v144[1] */,
  bool v145
){
  #pragma HLS inline OFF
  if (v145) {	// L324
    for (int v146 = 0; v146 < 2; v146++) {	// L325
      for (int v147 = 0; v147 < 2; v147++) {	// L326
        for (int v148 = 0; v148 < 2; v148++) {	// L327
          for (int v149 = 0; v149 < 32; v149++) {	// L328
            for (int v150 = 0; v150 < 8; v150++) {	// L329
            #pragma HLS pipeline II=1
              ap_int<128> v151 = v143[(v149 + (v146 * 32))][(v150 + (v148 * 8))];	// L330
              ap_axiu<128, 0 ,0 ,0> v144_axiu;
              v144_axiu.data = v151;
              v144_axiu.keep = -1;
              v144.write(v144_axiu); //v144              v144 = v151;	// L331
            }
          }
        }
      }
    }
  }
}

template<int NC>
void send6(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v152 /* v152[1] */,
  hls::stream< ap_int<128> > &v153 /* v153[1] */
){
  #pragma HLS inline OFF
  ap_int<128> v154[64][16];	// L345
  #pragma HLS bind_storage variable=v154 type=ram_s2p impl=bram
  ap_int<128> v155[64][16];	// L346
  #pragma HLS bind_storage variable=v155 type=ram_s2p impl=bram
  for (int v156 = 0; v156 < 2; v156++) {	// L347
    for (int v157 = 0; v157 < 2; v157++) {	// L348
      for (int v158 = 0; v158 < 2; v158++) {	// L349
        int v159 = v157 * 2;	// L350
        int v160 = v158 + v159;	// L351
        int v161 = v156 * 4;	// L352
        int v162 = v160 + v161;	// L353
        int v163 = v162 % 2;	// L354
        bool v164 = v163 == 0;	// L355
        bool v165 = v162 != 0;	// L356
        if (v164) {	// L357
          send6_0(v153, v154, 1);	// L358
          send6_1(v155, v152, v165);	// L359
        } else {
          send6_0(v153, v155, 1);	// L361
          send6_1(v154, v152, v165);	// L362
        }
      }
    }
  }
  send6_1(v155, v152, 1);	// L367
}

void send6_top(
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v166 /* v166[1] */,
  hls::stream< ap_int<128> > &v167 /* v167[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v168 /* v168[1] */,
  hls::stream< ap_int<128> > &v169 /* v169[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v170 /* v170[1] */,
  hls::stream< ap_int<128> > &v171 /* v171[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v172 /* v172[1] */,
  hls::stream< ap_int<128> > &v173 /* v173[1] */
){
  #pragma HLS inline OFF
  send6<0>(v166, v167);	// L371
  send6<1>(v168, v169);	// L372
  send6<2>(v170, v171);	// L373
  send6<3>(v172, v173);	// L374
}

template<int NC>
void store0_0(
  hls::stream< ap_int<128> > &v174 /* v174[1] */,
  hls::stream< ap_int<512> > &v175 /* v175[1] */
){
  #pragma HLS inline OFF
  for (int v176 = 0; v176 < 2; v176++) {	// L379
    for (int v177 = 0; v177 < 2; v177++) {	// L380
      for (int v178 = 0; v178 < 2; v178++) {	// L381
        for (int v179 = 0; v179 < 2; v179++) {	// L382
          for (int v180 = 0; v180 < 32; v180++) {	// L383
            for (int v181 = 0; v181 < 2; v181++) {	// L384
              for (int v182 = 0; v182 < 2; v182++) {	// L385
              #pragma HLS pipeline II=4
                ap_int<512> v183 = 0;
                for (int v184 = 0; v184 < 4; v184++) {	// L387
                #pragma HLS pipeline II=1
                  ap_int<128> v185 = v174.read(); //v174                  v185 = v174;	// L388
                  int v186 = ((v184 * 128) + 127);	// L389
                  int v187 = (v184 * 128);	// L390
                  v183(v186, v187) = v185;	// L391
                }
                v175.write(v183); //v175                v175 = v183;	// L393
              }
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v188 /* v188[1] */,
  hls::stream< ap_int<512> > &v189 /* v189[1] */,
  hls::stream< ap_int<128> > &v190 /* v190[1] */,
  hls::stream< ap_int<512> > &v191 /* v191[1] */,
  hls::stream< ap_int<128> > &v192 /* v192[1] */,
  hls::stream< ap_int<512> > &v193 /* v193[1] */,
  hls::stream< ap_int<128> > &v194 /* v194[1] */,
  hls::stream< ap_int<512> > &v195 /* v195[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v188, v189);	// L404
  store0_0<1>(v190, v191);	// L405
  store0_0<2>(v192, v193);	// L406
  store0_0<3>(v194, v195);	// L407
}

template<int NC>
void store0(
  ap_int<512> v196[256][16],
  hls::stream< ap_int<512> > &v197 /* v197[1] */,
  hls::stream< ap_int<512> > &v198 /* v198[1] */,
  hls::stream< ap_int<512> > &v199 /* v199[1] */,
  hls::stream< ap_int<512> > &v200 /* v200[1] */
){
  #pragma HLS inline OFF
  for (int v201 = 0; v201 < 2; v201++) {	// L412
    for (int v202 = 0; v202 < 2; v202++) {	// L413
      for (int v203 = 0; v203 < 2; v203++) {	// L414
        for (int v204 = 0; v204 < 2; v204++) {	// L415
          for (int v205 = 0; v205 < 32; v205++) {	// L416
            for (int v206 = 0; v206 < 2; v206++) {	// L417
              for (int v207 = 0; v207 < 4; v207++) {	// L418
              #pragma HLS pipeline II=1
                bool v208 = v207 < 2;	// L419
                ap_int<512> v209;
                if (v208) {	// L420
                  ap_int<512> v210 = v200.read(); //v200                  v210 = v200;	// L421
                  v209 = v210;	// L422
                } else {
                  ap_int<512> v211 = v199.read(); //v199                  v211 = v199;	// L424
                  v209 = v211;	// L425
                }
                v196[(((v205 + (v204 * 64)) + (v201 * 128)) + 32)][((v207 + (v206 * 4)) + (v202 * 8))] = v209;	// L427
              }
            }
          }
        }
        for (int v212 = 0; v212 < 2; v212++) {	// L432
          for (int v213 = 0; v213 < 32; v213++) {	// L433
            for (int v214 = 0; v214 < 2; v214++) {	// L434
              for (int v215 = 0; v215 < 4; v215++) {	// L435
              #pragma HLS pipeline II=1
                bool v216 = v215 < 2;	// L436
                ap_int<512> v217;
                if (v216) {	// L437
                  ap_int<512> v218 = v198.read(); //v198                  v218 = v198;	// L438
                  v217 = v218;	// L439
                } else {
                  ap_int<512> v219 = v197.read(); //v197                  v219 = v197;	// L441
                  v217 = v219;	// L442
                }
                v196[((v213 + (v212 * 64)) + (v201 * 128))][((v215 + (v214 * 4)) + (v202 * 8))] = v217;	// L444
              }
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v220[256][16],
  hls::stream< ap_int<512> > &v221 /* v221[1] */,
  hls::stream< ap_int<512> > &v222 /* v222[1] */,
  hls::stream< ap_int<512> > &v223 /* v223[1] */,
  hls::stream< ap_int<512> > &v224 /* v224[1] */
){
  #pragma HLS inline OFF
  store0<0>(v220, v221, v222, v223, v224);	// L455
}

template<int NC>
void load0(
  ap_int<512> v225[256][16],
  hls::stream< ap_int<512> > &v226 /* v226[1] */,
  hls::stream< ap_int<512> > &v227 /* v227[1] */,
  hls::stream< ap_int<512> > &v228 /* v228[1] */,
  hls::stream< ap_int<512> > &v229 /* v229[1] */
){
  #pragma HLS inline OFF
  for (int v230 = 0; v230 < 2; v230++) {	// L460
    for (int v231 = 0; v231 < 2; v231++) {	// L461
      for (int v232 = 0; v232 < 2; v232++) {	// L462
        for (int v233 = 0; v233 < 2; v233++) {	// L463
          for (int v234 = 0; v234 < 32; v234++) {	// L464
            for (int v235 = 0; v235 < 2; v235++) {	// L465
              for (int v236 = 0; v236 < 4; v236++) {	// L466
              #pragma HLS pipeline II=1
                ap_int<512> v237 = v225[((v234 + (v233 * 64)) + (v230 * 128))][((v236 + (v235 * 4)) + (v232 * 8))];	// L467
                bool v238 = v236 < 2;	// L468
                if (v238) {	// L469
                  v228.write(v237); //v228                  v228 = v237;	// L470
                } else {
                  v229.write(v237); //v229                  v229 = v237;	// L472
                }
              }
            }
          }
        }
        for (int v239 = 0; v239 < 2; v239++) {	// L478
          for (int v240 = 0; v240 < 32; v240++) {	// L479
            for (int v241 = 0; v241 < 2; v241++) {	// L480
              for (int v242 = 0; v242 < 4; v242++) {	// L481
              #pragma HLS pipeline II=1
                ap_int<512> v243 = v225[(((v240 + (v239 * 64)) + (v230 * 128)) + 32)][((v242 + (v241 * 4)) + (v232 * 8))];	// L482
                bool v244 = v242 < 2;	// L483
                if (v244) {	// L484
                  v227.write(v243); //v227                  v227 = v243;	// L485
                } else {
                  v226.write(v243); //v226                  v226 = v243;	// L487
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
  ap_int<512> v245[256][16],
  hls::stream< ap_int<512> > &v246 /* v246[1] */,
  hls::stream< ap_int<512> > &v247 /* v247[1] */,
  hls::stream< ap_int<512> > &v248 /* v248[1] */,
  hls::stream< ap_int<512> > &v249 /* v249[1] */
){
  #pragma HLS inline OFF
  load0<0>(v245, v246, v247, v248, v249);	// L499
}

template<int NC>
void load0_3(
  hls::stream< ap_int<512> > &v250 /* v250[1] */,
  hls::stream< ap_int<128> > &v251 /* v251[1] */
){
  #pragma HLS inline OFF
  for (int v252 = 0; v252 < 2; v252++) {	// L503
    for (int v253 = 0; v253 < 2; v253++) {	// L504
      for (int v254 = 0; v254 < 2; v254++) {	// L505
        for (int v255 = 0; v255 < 2; v255++) {	// L506
          for (int v256 = 0; v256 < 32; v256++) {	// L507
            for (int v257 = 0; v257 < 2; v257++) {	// L508
              for (int v258 = 0; v258 < 2; v258++) {	// L509
              #pragma HLS pipeline II=4
                ap_int<512> v259 = v250.read(); //v250                v259 = v250;	// L510
                for (int v260 = 0; v260 < 4; v260++) {	// L511
                #pragma HLS pipeline II=1
                  int v261 = ((v260 * 128) + 127);	// L512
                  int v262 = (v260 * 128);	// L513
                  ap_int<128> v263 = v259(v261, v262);	// L514
                  v251.write(v263); //v251                  v251 = v263;	// L515
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
  hls::stream< ap_int<512> > &v264 /* v264[1] */,
  hls::stream< ap_int<128> > &v265 /* v265[1] */,
  hls::stream< ap_int<512> > &v266 /* v266[1] */,
  hls::stream< ap_int<128> > &v267 /* v267[1] */,
  hls::stream< ap_int<512> > &v268 /* v268[1] */,
  hls::stream< ap_int<128> > &v269 /* v269[1] */,
  hls::stream< ap_int<512> > &v270 /* v270[1] */,
  hls::stream< ap_int<128> > &v271 /* v271[1] */,
  hls::stream< ap_int<512> > &v272 /* v272[1] */,
  hls::stream< ap_int<128> > &v273 /* v273[1] */,
  hls::stream< ap_int<512> > &v274 /* v274[1] */,
  hls::stream< ap_int<128> > &v275 /* v275[1] */,
  hls::stream< ap_int<512> > &v276 /* v276[1] */,
  hls::stream< ap_int<128> > &v277 /* v277[1] */,
  hls::stream< ap_int<512> > &v278 /* v278[1] */,
  hls::stream< ap_int<128> > &v279 /* v279[1] */
){
  #pragma HLS inline OFF
  load0_3<0>(v264, v265);	// L527
  load0_3<1>(v266, v267);	// L528
  load0_3<2>(v268, v269);	// L529
  load0_3<3>(v270, v271);	// L530
  load0_3<4>(v272, v273);	// L531
  load0_3<5>(v274, v275);	// L532
  load0_3<6>(v276, v277);	// L533
  load0_3<7>(v278, v279);	// L534
}

template<int NC>
void load1(
  ap_int<512> v280[256][16],
  hls::stream< ap_int<512> > &v281 /* v281[1] */,
  hls::stream< ap_int<512> > &v282 /* v282[1] */,
  hls::stream< ap_int<512> > &v283 /* v283[1] */,
  hls::stream< ap_int<512> > &v284 /* v284[1] */
){
  #pragma HLS inline OFF
  for (int v285 = 0; v285 < 2; v285++) {	// L539
    for (int v286 = 0; v286 < 2; v286++) {	// L540
      for (int v287 = 0; v287 < 2; v287++) {	// L541
        for (int v288 = 0; v288 < 2; v288++) {	// L542
          for (int v289 = 0; v289 < 32; v289++) {	// L543
            for (int v290 = 0; v290 < 2; v290++) {	// L544
              for (int v291 = 0; v291 < 4; v291++) {	// L545
              #pragma HLS pipeline II=1
                ap_int<512> v292 = v280[((v289 + (v288 * 64)) + (v287 * 128))][((v291 + (v290 * 4)) + (v286 * 8))];	// L546
                bool v293 = v291 < 2;	// L547
                if (v293) {	// L548
                  v282.write(v292); //v282                  v282 = v292;	// L549
                } else {
                  v283.write(v292); //v283                  v283 = v292;	// L551
                }
              }
            }
          }
        }
        for (int v294 = 0; v294 < 2; v294++) {	// L557
          for (int v295 = 0; v295 < 32; v295++) {	// L558
            for (int v296 = 0; v296 < 2; v296++) {	// L559
              for (int v297 = 0; v297 < 4; v297++) {	// L560
              #pragma HLS pipeline II=1
                ap_int<512> v298 = v280[(((v295 + (v294 * 64)) + (v287 * 128)) + 32)][((v297 + (v296 * 4)) + (v286 * 8))];	// L561
                bool v299 = v297 < 2;	// L562
                if (v299) {	// L563
                  v284.write(v298); //v284                  v284 = v298;	// L564
                } else {
                  v281.write(v298); //v281                  v281 = v298;	// L566
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
  ap_int<512> v300[256][16],
  hls::stream< ap_int<512> > &v301 /* v301[1] */,
  hls::stream< ap_int<512> > &v302 /* v302[1] */,
  hls::stream< ap_int<512> > &v303 /* v303[1] */,
  hls::stream< ap_int<512> > &v304 /* v304[1] */
){
  #pragma HLS inline OFF
  load1<0>(v300, v301, v302, v303, v304);	// L578
}

void gemm_pl(
  ap_int<512> v305[256][16],
  ap_int<512> v306[256][16],
  ap_int<512> v307[256][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v308 /* v308[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v309 /* v309[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v310 /* v310[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v311 /* v311[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v312 /* v312[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v313 /* v313[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v314 /* v314[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v315 /* v315[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v316 /* v316[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v317 /* v317[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v318 /* v318[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v319 /* v319[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v320 /* v320[1] */;	// L583
  hls::stream< ap_int<128> > v321 /* v321[1] */;	// L584
  hls::stream< ap_int<128> > v322 /* v322[1] */;	// L585
  hls::stream< ap_int<128> > v323 /* v323[1] */;	// L586
  hls::stream< ap_int<128> > v324 /* v324[1] */;	// L587
  hls::stream< ap_int<128> > v325 /* v325[1] */;	// L588
  hls::stream< ap_int<128> > v326 /* v326[1] */;	// L589
  hls::stream< ap_int<128> > v327 /* v327[1] */;	// L590
  hls::stream< ap_int<128> > v328 /* v328[1] */;	// L591
  hls::stream< ap_int<128> > v329 /* v329[1] */;	// L592
  hls::stream< ap_int<128> > v330 /* v330[1] */;	// L593
  hls::stream< ap_int<128> > v331 /* v331[1] */;	// L594
  ap_int<128> v332[64][16];	// L595
  #pragma HLS bind_storage variable=v332 type=ram_t2p impl=uram
  for (int v333 = 0; v333 < 64; v333++) {	// L596
    for (int v334 = 0; v334 < 16; v334++) {	// L597
    #pragma HLS pipeline II=1
      v332[v333][v334] = 0;	// L598
    }
  }
  ap_int<128> v335[64][16];	// L601
  #pragma HLS bind_storage variable=v335 type=ram_t2p impl=uram
  for (int v336 = 0; v336 < 64; v336++) {	// L602
    for (int v337 = 0; v337 < 16; v337++) {	// L603
    #pragma HLS pipeline II=1
      v335[v336][v337] = 0;	// L604
    }
  }
  ap_int<128> v338[64][16];	// L607
  #pragma HLS bind_storage variable=v338 type=ram_t2p impl=uram
  for (int v339 = 0; v339 < 64; v339++) {	// L608
    for (int v340 = 0; v340 < 16; v340++) {	// L609
    #pragma HLS pipeline II=1
      v338[v339][v340] = 0;	// L610
    }
  }
  ap_int<128> v341[64][16];	// L613
  #pragma HLS bind_storage variable=v341 type=ram_t2p impl=uram
  for (int v342 = 0; v342 < 64; v342++) {	// L614
    for (int v343 = 0; v343 < 16; v343++) {	// L615
    #pragma HLS pipeline II=1
      v341[v342][v343] = 0;	// L616
    }
  }
  hls::stream< ap_int<512> > v344 /* v344[1] */;	// L619
  #pragma HLS stream variable=v344 depth=2
  hls::stream< ap_int<512> > v345 /* v345[1] */;	// L620
  #pragma HLS stream variable=v345 depth=2
  hls::stream< ap_int<512> > v346 /* v346[1] */;	// L621
  #pragma HLS stream variable=v346 depth=2
  hls::stream< ap_int<512> > v347 /* v347[1] */;	// L622
  #pragma HLS stream variable=v347 depth=2
  hls::stream< ap_int<512> > v348 /* v348[1] */;	// L623
  #pragma HLS stream variable=v348 depth=2
  hls::stream< ap_int<512> > v349 /* v349[1] */;	// L624
  #pragma HLS stream variable=v349 depth=2
  hls::stream< ap_int<512> > v350 /* v350[1] */;	// L625
  #pragma HLS stream variable=v350 depth=2
  hls::stream< ap_int<512> > v351 /* v351[1] */;	// L626
  #pragma HLS stream variable=v351 depth=2
  hls::stream< ap_int<512> > v352 /* v352[1] */;	// L627
  #pragma HLS stream variable=v352 depth=2
  hls::stream< ap_int<512> > v353 /* v353[1] */;	// L628
  #pragma HLS stream variable=v353 depth=2
  hls::stream< ap_int<512> > v354 /* v354[1] */;	// L629
  #pragma HLS stream variable=v354 depth=2
  hls::stream< ap_int<512> > v355 /* v355[1] */;	// L630
  #pragma HLS stream variable=v355 depth=2
  send3_top(v311, v328, v314, v326, v316, v330, v315, v327);	// L631
  receive2_top(v317, v322, v309, v320, v312, v323, v318, v321);	// L632
  send6_top(v310, v325, v313, v331, v308, v324, v319, v329);	// L633
  store0_0_top(v320, v344, v321, v345, v322, v346, v323, v347);	// L634
  store0_top(v307, v345, v344, v347, v346);	// L635
  load0_top(v305, v348, v349, v351, v350);	// L636
  load0_3_top(v351, v331, v350, v329, v349, v325, v348, v324, v355, v330, v354, v328, v353, v327, v352, v326);	// L637
  load1_top(v306, v352, v355, v353, v354);	// L638
}

void top(
  ap_int<512> v356[256][16],
  ap_int<512> v357[256][16],
  ap_int<512> v358[256][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v359 /* v359[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v360 /* v360[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v361 /* v361[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v362 /* v362[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v363 /* v363[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v364 /* v364[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v365 /* v365[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v366 /* v366[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v367 /* v367[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v368 /* v368[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v369 /* v369[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v370 /* v370[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v356
  #pragma HLS interface s_axilite bundle=control port=v356
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v357
  #pragma HLS interface s_axilite bundle=control port=v357
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v358
  #pragma HLS interface s_axilite bundle=control port=v358
  #pragma HLS interface axis port=v359
  #pragma HLS interface axis port=v360
  #pragma HLS interface axis port=v361
  #pragma HLS interface axis port=v362
  #pragma HLS interface axis port=v363
  #pragma HLS interface axis port=v364
  #pragma HLS interface axis port=v365
  #pragma HLS interface axis port=v366
  #pragma HLS interface axis port=v367
  #pragma HLS interface axis port=v368
  #pragma HLS interface axis port=v369
  #pragma HLS interface axis port=v370

  gemm_pl(v356, v357, v358, v359, v360, v361, v362, v363, v364, v365, v366, v367, v368, v369, v370);	// L677
}


