
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
      }
      for (int v122 = 0; v122 < 2; v122++) {	// L286
        for (int v123 = 0; v123 < 32; v123++) {	// L287
          for (int v124 = 0; v124 < 2; v124++) {	// L288
            for (int v125 = 0; v125 < 8; v125++) {	// L289
            #pragma HLS pipeline II=1
              ap_int<128> v126 = v81[(v123 + (v122 * 32))][(v125 + (v124 * 8))];	// L290
              v80.write(v126); //v80              v80 = v126;	// L291
              v81[(v123 + (v122 * 32))][(v125 + (v124 * 8))] = 0;	// L292
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
        for (int v179 = 0; v179 < 32; v179++) {	// L382
          for (int v180 = 0; v180 < 2; v180++) {	// L383
            for (int v181 = 0; v181 < 2; v181++) {	// L384
            #pragma HLS pipeline II=4
              ap_int<512> v182 = 0;
              for (int v183 = 0; v183 < 4; v183++) {	// L386
              #pragma HLS pipeline II=1
                ap_int<128> v184 = v174.read(); //v174                v184 = v174;	// L387
                int v185 = ((v183 * 128) + 127);	// L388
                int v186 = (v183 * 128);	// L389
                v182(v185, v186) = v184;	// L390
              }
              v175.write(v182); //v175              v175 = v182;	// L392
            }
          }
        }
      }
    }
  }
}

void store0_0_top(
  hls::stream< ap_int<128> > &v187 /* v187[1] */,
  hls::stream< ap_int<512> > &v188 /* v188[1] */,
  hls::stream< ap_int<128> > &v189 /* v189[1] */,
  hls::stream< ap_int<512> > &v190 /* v190[1] */,
  hls::stream< ap_int<128> > &v191 /* v191[1] */,
  hls::stream< ap_int<512> > &v192 /* v192[1] */,
  hls::stream< ap_int<128> > &v193 /* v193[1] */,
  hls::stream< ap_int<512> > &v194 /* v194[1] */
){
  #pragma HLS inline OFF
  store0_0<0>(v187, v188);	// L402
  store0_0<1>(v189, v190);	// L403
  store0_0<2>(v191, v192);	// L404
  store0_0<3>(v193, v194);	// L405
}

template<int NC>
void store0(
  ap_int<512> v195[256][16],
  hls::stream< ap_int<512> > &v196 /* v196[1] */,
  hls::stream< ap_int<512> > &v197 /* v197[1] */,
  hls::stream< ap_int<512> > &v198 /* v198[1] */,
  hls::stream< ap_int<512> > &v199 /* v199[1] */
){
  #pragma HLS inline OFF
  for (int v200 = 0; v200 < 2; v200++) {	// L410
    for (int v201 = 0; v201 < 2; v201++) {	// L411
      for (int v202 = 0; v202 < 2; v202++) {	// L412
        for (int v203 = 0; v203 < 32; v203++) {	// L413
          for (int v204 = 0; v204 < 2; v204++) {	// L414
            for (int v205 = 0; v205 < 4; v205++) {	// L415
            #pragma HLS pipeline II=1
              bool v206 = v205 < 2;	// L416
              ap_int<512> v207;
              if (v206) {	// L417
                ap_int<512> v208 = v196.read(); //v196                v208 = v196;	// L418
                v207 = v208;	// L419
              } else {
                ap_int<512> v209 = v197.read(); //v197                v209 = v197;	// L421
                v207 = v209;	// L422
              }
              v195[((v203 + (v202 * 64)) + (v200 * 128))][((v205 + (v204 * 4)) + (v201 * 8))] = v207;	// L424
            }
          }
        }
      }
      for (int v210 = 0; v210 < 2; v210++) {	// L429
        for (int v211 = 0; v211 < 32; v211++) {	// L430
          for (int v212 = 0; v212 < 2; v212++) {	// L431
            for (int v213 = 0; v213 < 4; v213++) {	// L432
            #pragma HLS pipeline II=1
              bool v214 = v213 < 2;	// L433
              ap_int<512> v215;
              if (v214) {	// L434
                ap_int<512> v216 = v199.read(); //v199                v216 = v199;	// L435
                v215 = v216;	// L436
              } else {
                ap_int<512> v217 = v198.read(); //v198                v217 = v198;	// L438
                v215 = v217;	// L439
              }
              v195[(((v211 + (v210 * 64)) + (v200 * 128)) + 32)][((v213 + (v212 * 4)) + (v201 * 8))] = v215;	// L441
            }
          }
        }
      }
    }
  }
}

void store0_top(
  ap_int<512> v218[256][16],
  hls::stream< ap_int<512> > &v219 /* v219[1] */,
  hls::stream< ap_int<512> > &v220 /* v220[1] */,
  hls::stream< ap_int<512> > &v221 /* v221[1] */,
  hls::stream< ap_int<512> > &v222 /* v222[1] */
){
  #pragma HLS inline OFF
  store0<0>(v218, v219, v220, v221, v222);	// L451
}

template<int NC>
void load0(
  ap_int<512> v223[256][16],
  hls::stream< ap_int<512> > &v224 /* v224[1] */,
  hls::stream< ap_int<512> > &v225 /* v225[1] */,
  hls::stream< ap_int<512> > &v226 /* v226[1] */,
  hls::stream< ap_int<512> > &v227 /* v227[1] */
){
  #pragma HLS inline OFF
  for (int v228 = 0; v228 < 2; v228++) {	// L456
    for (int v229 = 0; v229 < 2; v229++) {	// L457
      for (int v230 = 0; v230 < 2; v230++) {	// L458
        for (int v231 = 0; v231 < 2; v231++) {	// L459
          for (int v232 = 0; v232 < 32; v232++) {	// L460
            for (int v233 = 0; v233 < 2; v233++) {	// L461
              for (int v234 = 0; v234 < 4; v234++) {	// L462
              #pragma HLS pipeline II=1
                ap_int<512> v235 = v223[((v232 + (v231 * 64)) + (v228 * 128))][((v234 + (v233 * 4)) + (v230 * 8))];	// L463
                bool v236 = v234 < 2;	// L464
                if (v236) {	// L465
                  v224.write(v235); //v224                  v224 = v235;	// L466
                } else {
                  v225.write(v235); //v225                  v225 = v235;	// L468
                }
              }
            }
          }
        }
        for (int v237 = 0; v237 < 2; v237++) {	// L474
          for (int v238 = 0; v238 < 32; v238++) {	// L475
            for (int v239 = 0; v239 < 2; v239++) {	// L476
              for (int v240 = 0; v240 < 4; v240++) {	// L477
              #pragma HLS pipeline II=1
                ap_int<512> v241 = v223[(((v238 + (v237 * 64)) + (v228 * 128)) + 32)][((v240 + (v239 * 4)) + (v230 * 8))];	// L478
                bool v242 = v240 < 2;	// L479
                if (v242) {	// L480
                  v227.write(v241); //v227                  v227 = v241;	// L481
                } else {
                  v226.write(v241); //v226                  v226 = v241;	// L483
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
  ap_int<512> v243[256][16],
  hls::stream< ap_int<512> > &v244 /* v244[1] */,
  hls::stream< ap_int<512> > &v245 /* v245[1] */,
  hls::stream< ap_int<512> > &v246 /* v246[1] */,
  hls::stream< ap_int<512> > &v247 /* v247[1] */
){
  #pragma HLS inline OFF
  load0<0>(v243, v244, v245, v246, v247);	// L495
}

template<int NC>
void load0_3(
  hls::stream< ap_int<512> > &v248 /* v248[1] */,
  hls::stream< ap_int<128> > &v249 /* v249[1] */
){
  #pragma HLS inline OFF
  for (int v250 = 0; v250 < 2; v250++) {	// L499
    for (int v251 = 0; v251 < 2; v251++) {	// L500
      for (int v252 = 0; v252 < 2; v252++) {	// L501
        for (int v253 = 0; v253 < 2; v253++) {	// L502
          for (int v254 = 0; v254 < 32; v254++) {	// L503
            for (int v255 = 0; v255 < 2; v255++) {	// L504
              for (int v256 = 0; v256 < 2; v256++) {	// L505
              #pragma HLS pipeline II=4
                ap_int<512> v257 = v248.read(); //v248                v257 = v248;	// L506
                for (int v258 = 0; v258 < 4; v258++) {	// L507
                #pragma HLS pipeline II=1
                  int v259 = ((v258 * 128) + 127);	// L508
                  int v260 = (v258 * 128);	// L509
                  ap_int<128> v261 = v257(v259, v260);	// L510
                  v249.write(v261); //v249                  v249 = v261;	// L511
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
  hls::stream< ap_int<512> > &v262 /* v262[1] */,
  hls::stream< ap_int<128> > &v263 /* v263[1] */,
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
  hls::stream< ap_int<128> > &v277 /* v277[1] */
){
  #pragma HLS inline OFF
  load0_3<0>(v262, v263);	// L523
  load0_3<1>(v264, v265);	// L524
  load0_3<2>(v266, v267);	// L525
  load0_3<3>(v268, v269);	// L526
  load0_3<4>(v270, v271);	// L527
  load0_3<5>(v272, v273);	// L528
  load0_3<6>(v274, v275);	// L529
  load0_3<7>(v276, v277);	// L530
}

template<int NC>
void load1(
  ap_int<512> v278[256][16],
  hls::stream< ap_int<512> > &v279 /* v279[1] */,
  hls::stream< ap_int<512> > &v280 /* v280[1] */,
  hls::stream< ap_int<512> > &v281 /* v281[1] */,
  hls::stream< ap_int<512> > &v282 /* v282[1] */
){
  #pragma HLS inline OFF
  for (int v283 = 0; v283 < 2; v283++) {	// L535
    for (int v284 = 0; v284 < 2; v284++) {	// L536
      for (int v285 = 0; v285 < 2; v285++) {	// L537
        for (int v286 = 0; v286 < 2; v286++) {	// L538
          for (int v287 = 0; v287 < 32; v287++) {	// L539
            for (int v288 = 0; v288 < 2; v288++) {	// L540
              for (int v289 = 0; v289 < 4; v289++) {	// L541
              #pragma HLS pipeline II=1
                ap_int<512> v290 = v278[((v287 + (v286 * 64)) + (v285 * 128))][((v289 + (v288 * 4)) + (v284 * 8))];	// L542
                bool v291 = v289 < 2;	// L543
                if (v291) {	// L544
                  v279.write(v290); //v279                  v279 = v290;	// L545
                } else {
                  v280.write(v290); //v280                  v280 = v290;	// L547
                }
              }
            }
          }
        }
        for (int v292 = 0; v292 < 2; v292++) {	// L553
          for (int v293 = 0; v293 < 32; v293++) {	// L554
            for (int v294 = 0; v294 < 2; v294++) {	// L555
              for (int v295 = 0; v295 < 4; v295++) {	// L556
              #pragma HLS pipeline II=1
                ap_int<512> v296 = v278[(((v293 + (v292 * 64)) + (v285 * 128)) + 32)][((v295 + (v294 * 4)) + (v284 * 8))];	// L557
                bool v297 = v295 < 2;	// L558
                if (v297) {	// L559
                  v281.write(v296); //v281                  v281 = v296;	// L560
                } else {
                  v282.write(v296); //v282                  v282 = v296;	// L562
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
  ap_int<512> v298[256][16],
  hls::stream< ap_int<512> > &v299 /* v299[1] */,
  hls::stream< ap_int<512> > &v300 /* v300[1] */,
  hls::stream< ap_int<512> > &v301 /* v301[1] */,
  hls::stream< ap_int<512> > &v302 /* v302[1] */
){
  #pragma HLS inline OFF
  load1<0>(v298, v299, v300, v301, v302);	// L574
}

void gemm_pl(
  ap_int<512> v303[256][16],
  ap_int<512> v304[256][16],
  ap_int<512> v305[256][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v306 /* v306[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v307 /* v307[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v308 /* v308[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v309 /* v309[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v310 /* v310[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v311 /* v311[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v312 /* v312[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v313 /* v313[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v314 /* v314[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v315 /* v315[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v316 /* v316[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v317 /* v317[1] */
){
  #pragma HLS dataflow
  #pragma HLS inline OFF
  hls::stream< ap_int<128> > v318 /* v318[1] */;	// L579
  hls::stream< ap_int<128> > v319 /* v319[1] */;	// L580
  hls::stream< ap_int<128> > v320 /* v320[1] */;	// L581
  hls::stream< ap_int<128> > v321 /* v321[1] */;	// L582
  hls::stream< ap_int<128> > v322 /* v322[1] */;	// L583
  hls::stream< ap_int<128> > v323 /* v323[1] */;	// L584
  hls::stream< ap_int<128> > v324 /* v324[1] */;	// L585
  hls::stream< ap_int<128> > v325 /* v325[1] */;	// L586
  hls::stream< ap_int<128> > v326 /* v326[1] */;	// L587
  hls::stream< ap_int<128> > v327 /* v327[1] */;	// L588
  hls::stream< ap_int<128> > v328 /* v328[1] */;	// L589
  hls::stream< ap_int<128> > v329 /* v329[1] */;	// L590
  hls::stream< ap_int<512> > v342 /* v342[1] */;	// L615
  #pragma HLS stream variable=v342 depth=2
  hls::stream< ap_int<512> > v343 /* v343[1] */;	// L616
  #pragma HLS stream variable=v343 depth=2
  hls::stream< ap_int<512> > v344 /* v344[1] */;	// L617
  #pragma HLS stream variable=v344 depth=2
  hls::stream< ap_int<512> > v345 /* v345[1] */;	// L618
  #pragma HLS stream variable=v345 depth=2
  hls::stream< ap_int<512> > v346 /* v346[1] */;	// L619
  #pragma HLS stream variable=v346 depth=2
  hls::stream< ap_int<512> > v347 /* v347[1] */;	// L620
  #pragma HLS stream variable=v347 depth=2
  hls::stream< ap_int<512> > v348 /* v348[1] */;	// L621
  #pragma HLS stream variable=v348 depth=2
  hls::stream< ap_int<512> > v349 /* v349[1] */;	// L622
  #pragma HLS stream variable=v349 depth=2
  hls::stream< ap_int<512> > v350 /* v350[1] */;	// L623
  #pragma HLS stream variable=v350 depth=2
  hls::stream< ap_int<512> > v351 /* v351[1] */;	// L624
  #pragma HLS stream variable=v351 depth=2
  hls::stream< ap_int<512> > v352 /* v352[1] */;	// L625
  #pragma HLS stream variable=v352 depth=2
  hls::stream< ap_int<512> > v353 /* v353[1] */;	// L626
  #pragma HLS stream variable=v353 depth=2
  send3_top(v307, v326, v306, v324, v311, v328, v310, v325);	// L627
  receive2_top(v312, v320, v317, v318, v316, v321, v309, v319);	// L628
  send6_top(v308, v323, v313, v329, v315, v322, v314, v327);	// L629
  store0_0_top(v321, v342, v320, v343, v319, v344, v318, v345);	// L630
  store0_top(v305, v345, v344, v342, v343);	// L631
  load0_top(v303, v349, v348, v346, v347);	// L632
  load0_3_top(v349, v329, v348, v327, v347, v323, v346, v322, v353, v328, v352, v326, v351, v325, v350, v324);	// L633
  load1_top(v304, v353, v351, v352, v350);	// L634
}

void top(
  ap_int<512> v354[256][16],
  ap_int<512> v355[256][16],
  ap_int<512> v356[256][16],
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v357 /* v357[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v358 /* v358[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v359 /* v359[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v360 /* v360[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v361 /* v361[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v362 /* v362[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v363 /* v363[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v364 /* v364[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v365 /* v365[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v366 /* v366[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v367 /* v367[1] */,
  hls::stream< ap_axiu<128, 0 ,0 ,0> > &v368 /* v368[1] */
){
  #pragma HLS interface s_axilite port=return bundle=control
  #pragma HLS interface m_axi offset=slave bundle=gmem0 port=v354
  #pragma HLS interface s_axilite bundle=control port=v354
  #pragma HLS interface m_axi offset=slave bundle=gmem1 port=v355
  #pragma HLS interface s_axilite bundle=control port=v355
  #pragma HLS interface m_axi offset=slave bundle=gmem2 port=v356
  #pragma HLS interface s_axilite bundle=control port=v356
  #pragma HLS interface axis port=v357
  #pragma HLS interface axis port=v358
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

  gemm_pl(v354, v355, v356, v357, v358, v359, v360, v361, v362, v363, v364, v365, v366, v367, v368);	// L673
}


