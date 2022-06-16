Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F454D81D
	for <lists+kvm-ppc@lfdr.de>; Thu, 16 Jun 2022 04:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358535AbiFPCJo (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 15 Jun 2022 22:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358697AbiFPCJY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 15 Jun 2022 22:09:24 -0400
X-Greylist: delayed 623 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Jun 2022 19:08:31 PDT
Received: from ah11-smtp.activegate-ss.jp (ah11-smtp.activegate-ss.jp [202.241.206.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070B15B3DA
        for <kvm-ppc@vger.kernel.org>; Wed, 15 Jun 2022 19:08:30 -0700 (PDT)
Received: from mail.d.activegate-ss.jp (unknown [10.16.39.39]) (envelope sender: <contact@studioz.co.jp>)
        (not using TLS) by ah11-smtp.activegate-ss.jp (Active!Hunter) with ESMTP id QK6C17243A;
        Thu, 16 Jun 2022 10:58:04 +0900
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-317597643bfso411037b3.20
        for <kvm-ppc@vger.kernel.org>; Wed, 15 Jun 2022 18:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:reply-to:mime-version:date:message-id
         :subject:to:content-transfer-encoding;
        bh=H1/2cSuog/LTuaGLym9LR/teFBf4ybbwq9M0iGPQ1V0=;
        b=oUKjAl9W79wzorEEI3q+26d6UMApfNQN6xwhVQybhz51CEJwuBoC0t1I7UddhX82uy
         al1Gcq83MJugohoZ1hkI7KV3eUmikYThTAb1cw1HpnDkDE5iVgACnrOtnk+Bumqy1KNM
         uBUMNXKMsheOP19CPXYlUy0VFDVq21TJ0gtzMF+JoWxkbzujw5jio38Bs145ieUaRCEZ
         qzlRNeO4ruFtZZ/Y6nMgZ+7XGommnTghQCt8XpZXKwMNJJemyXxy3kCj/tjlsxFjMixx
         DIIGuEDjDToCxB4OkuoaOzivE+dSM9/2gaXA23lBEarfvXgWzw9nnalLJP2mK4Y1aXmo
         jm0w==
X-Gm-Message-State: AJIora/P1IAwT51oTATwT4uClO7OIMmR33zUIWJUN9PyD2KeMyezK4CM
        ZJgAzrzaM+PhKRy3EPLDqE0iG535sQK9VIIRflelh6IXbBCuxM74BPe/c4nyaquMjGNcKxgPGpo
        GidF89q/VG6vAvxU3WAtc6XfZugm+6QnhWbWPkpMQdeCa8PJLhSlZPo5HdGuxKMmbmtyUquzErZ
        aUBChHMHHPwZQu96nKCP136+hviw/b1sKqxcuGnE4Q6bqTgujjGCQMagDOzc9eGOiPS/8NQeKYU
        ecoTP9Fx7fRTDgBEwxOVuXY/oUjTcv26jkjnwNcmPSftAZRSyDmt4tdrz1rtc8RtQ==
X-Received: by 2002:a81:8406:0:b0:316:b95c:a29b with SMTP id u6-20020a818406000000b00316b95ca29bmr3154067ywf.402.1655344682601;
        Wed, 15 Jun 2022 18:58:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uBvbCwgmS79Y8KfYft2SoqlYoC24BCeIEyjwg30N0wcxMwMfnjtH+iz70a4TCIa4X5pDBL1IG7lEbDMr5TGgk=
X-Received: by 2002:a81:8406:0:b0:316:b95c:a29b with SMTP id
 u6-20020a818406000000b00316b95ca29bmr3154050ywf.402.1655344682416; Wed, 15
 Jun 2022 18:58:02 -0700 (PDT)
Received: from 522611415571 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 Jun 2022 18:58:01 -0700
From:   =?UTF-8?B?U3R1ZGlvWuagquW8j+S8muekvg==?= <contact@studioz.co.jp>
Reply-To: contact@studioz.co.jp
X-Mailer: WPMailSMTP/Mailer/gmail 2.9.0
MIME-Version: 1.0
Date:   Wed, 15 Jun 2022 18:58:01 -0700
Message-ID: <CAPYqbGVoUg5D3ghiH4XedMMqW34UFXZwaB_G_WkmHZZqEWN8qw@mail.gmail.com>
Subject: =?UTF-8?B?U3R1ZGlvWuagquW8j+S8muekvuOAkOOBiuWVj+OBhOWQiOOCj+OBm+OCkuWPl+OBkeS7mA==?=
        =?UTF-8?B?44GR44G+44GX44Gf44CR?=
To:     kvm-ppc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_99,BAYES_999,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

5Lya56S+5ZCNOiDwn5KbIEhhdmUgeW91IGV2ZXIgdHJpZWQgdGhpcyBzZXggZ2FtZSBiZWZvcmU/
IEdJVkUgSVQgQSBUUlk6DQpodHRwczovL3F1ZWVuMjIucGFnZS5saW5rL3Bob3Rvcz9vaHE1ZyDw
n5KbDQrjgYrlkI3liY06IGQyYjBraw0K44Oh44O844Or44Ki44OJ44Os44K5OiBrdm0tcHBjQHZn
ZXIua2VybmVsLm9yZw0K44OX44Op44Kk44OQ44K344O844Od44Oq44K344O85ZCM5oSPOiDkuIro
qJjjga7jgIzjg5fjg6njgqTjg5Djgrfjg7zjg53jg6rjgrfjg7zjgI3jgavlkIzmhI/jga7kuIrj
gIHnlLPjgZfovrzjgb/jgb7jgZkNCuS7tuWQjTogcHViYmNiDQrlhoXlrrk6DQppbzJwN3YNCg0K
LS0gDQrjgZPjga7jg6Hjg7zjg6vjga8gU3R1ZGlvWuagquW8j+S8muekviAoaHR0cHM6Ly9zdHVk
aW96LmNvLmpwLykg44Gu44GK5ZWP44GE5ZCI44KP44Gb44OV44Kp44O844Og44GL44KJ6YCB5L+h
44GV44KM44G+44GX44GfDQo=
