Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E412701540
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 May 2023 10:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjEMIZQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 13 May 2023 04:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjEMIZP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 13 May 2023 04:25:15 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4575A2D78
        for <kvm-ppc@vger.kernel.org>; Sat, 13 May 2023 01:25:14 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-50be17a1eceso20134279a12.2
        for <kvm-ppc@vger.kernel.org>; Sat, 13 May 2023 01:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683966313; x=1686558313;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z7/UrOrH7WBlk+aHFLuoAPaV4sjjLKIsLUZnOqmSEYI=;
        b=hPwEvYzz9lLqhr27Sip6MZdscDpgkDCvoz8QpGz6vEJQM+cfqLomJ1nC3g1+12FBK3
         N3xF68/63YnofkyHXyF3jWSLIBkenU1z/i6aOrXGvzejeyOxeGObCLNiqt3BeFwimH7P
         c7CmS7S2jUmgJ0dzeE3FrNcnWiS8un3y8X8IUXfFLgk7NInfT9p2ZjJCAaMTXcdYs2gc
         JcHPt2AHCtj6qCy9Bz/ySw4rn7V0HRSK8KnPN5suqFqwWAMSgU7HD8GFiSPYycIbClx2
         ujBGeFiVuOrD5FSiPPFgEZzWrxtvuf/DyrmUbT7zUSwJ/YT7qw5ymuzkQAPG8WAeVDY2
         pQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683966313; x=1686558313;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7/UrOrH7WBlk+aHFLuoAPaV4sjjLKIsLUZnOqmSEYI=;
        b=lVIYlz6bIsl8ndj7X6zpdkFRlAKOVgy0mUpXoT6bnjV0WODoB/haTvU1zOWxYu9xWg
         2szToiV9c732w8928bYvK/B2/cnkJ76NiGm3mPhCJ5ngKXCEC7GmUlFRDdVY+ionH0z2
         UzpF/OOVAJurU+e8HCdvv14D+tNmW5AxuMy89iYFNxzhyxVVV1D6CsRnT+uJf4mVZgms
         /quTJHSUHCp+f2N0ilr3Ce1Gi2EkidG8NdiAau0OEnDPKUpr2jk/BCc54JmEAFkVtivp
         VoG5wBJT8BLXdJyUCaIUfkCyuoG5UO3IPnUlXMJ7GrpQgC+yPI/g5aBoxjGDFU7HEmUq
         3X9w==
X-Gm-Message-State: AC+VfDxyVDLzx6Z/3xUuAPvHOxIiRF6bn0VX+FjqFCjrq/Uk5beDFPQT
        lZLa9E3mO1fAO/GPrIGe8D2mrdzsosoG00WMiHs=
X-Google-Smtp-Source: ACHHUZ4Y0cPodwZ0hminpQ5IJyVWN5nEB2T1ZEGIyBmla01MYtDvNdNBfaR1KzAoOChj9PYiO69Zv5qsCu9e2ywAvc4=
X-Received: by 2002:a17:907:160d:b0:966:5035:6973 with SMTP id
 hb13-20020a170907160d00b0096650356973mr24356987ejc.50.1683966312467; Sat, 13
 May 2023 01:25:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a688:0:b0:20d:b602:5a42 with HTTP; Sat, 13 May 2023
 01:25:11 -0700 (PDT)
Reply-To: didieracouetey46@gmail.com
From:   "Mrs. Cristalina Georgieva" <samanthasamantha65433@gmail.com>
Date:   Sat, 13 May 2023 08:25:11 +0000
Message-ID: <CAHN4HM1hqrwc-+LKj_VbCcjEvvfXS+2oKbJNoZtOsLEg5j88jA@mail.gmail.com>
Subject: hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

5rOo5oSPOiDopqrmhJvjgarjgovln7rph5Hlj5fnm4rogIXjga7nmobmp5gNCg0KICAg5oWO6YeN
44Gr6Kqt44KA77yB77yB77yBDQoNCiAgIOOBk+OBrumbu+WtkOODoeODg+OCu+ODvOOCuOOBr+ap
n+WvhuOBp+OBguOCiuOAgeWOs+WvhuOBq+OBguOBquOBn+Wum+OBruOCguOBruOBp+OBmeOAgg0K
DQrjgYLjgarjgZ/jgYwxNeWEhOODieODq+imj+aooeOBruizh+mHkeOCkuWPl+OBkeWPluOBo+OB
puOBhOOBquOBhOOBruOBr+aYjuOCieOBi+OBp+OBmeOAguOBk+OCjOOBr+OAgemBjuWOu+OBruiF
kOaVl+OBl+OBn+aUv+W6nOW9ueS6uuOBjOWIqeW3seeahOOBqueQhueUseOBp+izh+mHkeOCkuOB
u+OBqOOCk+OBqeiHquWIhuOBn+OBoeOBoOOBkeOBruOCguOBruOBq+OBl+OAgeOBguOBquOBn+OB
ruizh+mHkeOCkuOBmeOBueOBpuipkOasuuOBl+OCiOOBhuOBqOOBl+OBpuWIqeeUqOOBl+OBn+OB
n+OCgeOBp+OBmeOAgg0K5Z+66YeR44CCIOOBk+OCjOOBq+OCiOOCiuOAgeOBiuWuouanmOWBtOOB
q+WkmuWkp+OBquaQjeWkseOBjOeZuueUn+OBl+OAgeizh+mHkeOBruWPl+OBkeWPluOCiuOBq+S4
jeW/heimgeOBqumBheOCjOOBjOeUn+OBmOOBvuOBl+OBn+OAgg0KDQrjgqTjg7Pjgr/jg7zjg53j
g7zjg6vjga7lm73lrrbkuK3lpK7lsYDjga/jgIHlm73pgKPjgajpgKPpgqbmjZzmn7vlsYDvvIhG
SULvvInjga7mlK/mj7TjgpLlj5fjgZHjgabjgIHnj77lm73pmpvpgJrosqjln7rph5Hnt4/oo4Hj
gavlr77jgZfjgIHjgYLjgarjgZ/jgoTku5bjga7kurrjgZ/jgaHjgavlr77jgZnjgovjgZnjgbnj
gabjga7lr77lpJblgrXli5njga7muIXnrpfjgpLmjqjpgLLjgZnjgovjgojjgYblp5Tku7vjgZnj
govjgZPjgajjgavmiJDlip/jgZfjgb7jgZfjgZ/jgIINCuWlkee0hOmHkeOAgeWuneOBj+OBmC/j
gq7jg6Pjg7Pjg5bjg6vjgIHnm7jntprjgarjganjgpLlj5fjgZHlj5bjgonjgarjgYTlgIvkurrj
gIIgQVRN44Kr44O844OJ44Gn5pSv5omV44GE44KS5Y+X44GR5Y+W44KK44G+44GZ44CCDQoNCk9S
QSDjg5Djg7Pjgq8g44Kr44O844OJOiDlkI3liY3jgYzmmpflj7fljJbjgZXjgozjgZ/jg5Hjg7zj
gr3jg4rjg6njgqTjgrrjgZXjgozjgZ8gT1JBIOODkOODs+OCryBBVE0NCuOCq+ODvOODieOCkueZ
uuihjOOBl+OBvuOBmeOAguOBk+OBruOCq+ODvOODieOCkuS9v+eUqOOBmeOCi+OBqOOAgVZpc2Eg
44Kr44O844OJ44Gu44Ot44K044GM5LuY44GE44Gm44GE44KLIEFUTSDjgYvjgokgMSDml6XjgYLj
gZ/jgormnIDlpKcgMjAsMDAwDQrjg4njg6vjgpLlvJXjgY3lh7rjgZnjgZPjgajjgYzjgafjgY3j
gb7jgZnjgIIg44G+44Gf44CBT1JBIOODkOODs+OCryDjgqvjg7zjg4njgpLkvb/nlKjjgZnjgovj
gajjgIHos4fph5HjgpLpioDooYzlj6PluqfjgavpgIHph5HjgafjgY3jgb7jgZnjgIIgQVRNDQrj
gqvjg7zjg4njgavjga/jgIHjgYLjgarjgZ/jga7lm73jgYrjgojjgbPkuJbnlYzkuK3jga7jganj
ga4gQVRNIOapn+OBp+OCguS9v+eUqOOBp+OBjeOCi+OBk+OBqOOCkuaYjueiuuOBq+OBmeOCi+OD
nuODi+ODpeOCouODq+OBjOS7mOWxnuOBl+OBpuOBhOOBvuOBmeOAgg0KDQros4fph5Hjga8gQVRN
IFZpc2Eg44Kr44O844OJ57WM55Sx44Gn6YCB44KJ44KM44CBRmVkRXggRXhwcmVzcyDntYznlLHj
gafphY3pgZTjgZXjgozjgb7jgZnjgIIg56eB44Gf44Gh44GvIEZlZEV4IEV4cHJlc3MNCuOBqOWl
kee0hOOCkue1kOOCk+OBp+OBhOOBvuOBmeOAgumAo+e1oeOBmeOCi+W/heimgeOBjOOBguOCi+OB
ruOBr+OAgU9SQSDpioDooYzjga7jg4fjgqPjg6zjgq/jgr/jg7zjgafjgYLjgosgTVIg44Gg44GR
44Gn44GZ44CCIERJRElFUiBBQ09VRVRFWQ0K44GT44Gu44Oh44O844Or44Ki44OJ44Os44K544GL
44KJOiAsIChkaWRpZXJhY291ZXRleTQ2QGdtYWlsLmNvbSkNCg0KDQrpgJrluLjjga7jg6zjg7zj
g4jjgpLotoXjgYjjgovph5HpoY3jgpLopoHmsYLjgZnjgovkurrjga/plpPpgZXjgYTjgarjgY/o
qZDmrLrluKvjgafjgYLjgorjgIHku5bjga7kurrjgavpgKPntaHjgpLlj5bjgaPjgZ/loLTlkIjj
ga/jgZ3jga7kurrjgajjga7pgKPntaHjgpLkuK3mraLjgZnjgovlv4XopoHjgYzjgYLjgovjgZPj
gajjgavms6jmhI/jgZfjgabjgY/jgaDjgZXjgYTjgIINCg0K44G+44Gf44CB44GU6LKg5ouF44GE
44Gf44Gg44GP44Gu44Gv6YWN6YCB5paZ44Gu44G/44Gn44GZ44Gu44Gn44GU5a6J5b+D44GP44Gg
44GV44GE44CCIOOBneOCjOS7peS4iuOBruOCguOBruOBr+OBguOCiuOBvuOBm+OCk++8gSDlv4Xo
poHjgarmg4XloLHjgajphY3pgIHmlpnjgpLlj5fjgZHlj5bjgaPjgabjgYvjgokgMg0K5Za25qWt
5pel5Lul5YaF44Gr6LOH6YeR44KS5Y+X44GR5Y+W44KL44GT44Go44KS5L+d6Ki844GX44G+44GZ
44CCDQoNCuazqDog56iO6YeR5omL5pWw5paZ44KS5ZCr44KB44CB44GZ44G544Gm44GvIElNRiDj
gajkuJbnlYzpioDooYzjgavjgojjgaPjgablh6bnkIbjgZXjgozjgovjgZ/jgoHjgIHmlK/miZXj
gYblv4XopoHjgYzjgYLjgovjga7jga8gRmVkRXgg44Gu6YWN6YCB5paZ44Gg44GR44Gn44GZ44CC
DQrjgZPjgozjga/jgIFGZWRFeCBFeHByZXNzIOOBriBDT0QgKOS7o+mHkeW8leaPmykg44K144O8
44OT44K544GM6KaP57SE44Gr44KI44KK5Zu96Zqb6YWN6YCB44Gr44Gv6YGp55So44GV44KM44Gq
44GE44Gf44KB44Gn44GZ44CCDQoNCjE1IOWEhOODieODq+ebuOW9k+OBruODleOCoeODs+ODieOC
kuODquODquODvOOCueOBmeOCi+OBq+OBr+OAgeiqpOmFjemAgeOCkumBv+OBkeOCi+OBn+OCgeOB
q+mFjemAgeaDheWgseOCkuaPkOS+m+OBmeOCi+W/heimgeOBjOOBguOCiuOBvuOBmeOAgg0KDQog
ICAxLiDjgYLjgarjgZ/jga7jg5Xjg6vjg43jg7zjg6AgLi4uLi4uLi4uLi4uLi4uLi4uLg0KMi4g
44GC44Gq44Gf44Gu5Zu9Li4uLi4NCjMuIOOBguOBquOBn+OBruihly4uLi4uDQo0LiDjgYLjgarj
gZ/jga7lrozlhajjgarkvY/miYAgLi4uLi4uDQo1LiDlm73nsY0gLi4uLi4uDQo2LiDnlJ/lubTm
nIjml6Uv5oCn5Yil4oCm4oCmDQo3LiDogbfmpa3igKbigKYNCjguIOmbu+ipseeVquWPt+KApuKA
pg0KOS4g6LK056S+44Gu44Oh44O844Or44Ki44OJ44Os44K5IOKApuKApg0KMTAuIOWAi+S6uuOD
oeODvOODq+OCouODieODrOOCuSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4NCjEx
LiDlm73pmpvjg5Hjgrnjg53jg7zjg4jjgb7jgZ/jga/mnInlirnjgarouqvliIboqLzmmI7mm7jj
ga7jgrPjg5Tjg7w6DQoNCuW/heimgeS6i+mgheOCkk1S44G+44Gn44GK6YCB44KK44GP44Gg44GV
44GE44CCIERJRElFUiBBQ09VRVRFWSBPcmFCYW5rIOODh+OCo+ODrOOCr+OCv+ODvOOAgeODoeOD
vOODq+OCouODieODrOOCuSA9DQooZGlkaWVyYWNvdWV0ZXk0NkBnbWFpbC5jb20pIOOBvuOBp+S7
iuOBmeOBkOOBlOmAo+e1oeOBj+OBoOOBleOBhOOAgg0KDQrjgYrjgoHjgafjgajjgYbjgZTjgZbj
gYTjgb7jgZkNCg==
