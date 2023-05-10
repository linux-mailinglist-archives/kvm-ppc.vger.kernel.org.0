Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667976FDFC3
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 May 2023 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbjEJOPx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 10 May 2023 10:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237356AbjEJOPw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 10 May 2023 10:15:52 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1032DC4B
        for <kvm-ppc@vger.kernel.org>; Wed, 10 May 2023 07:15:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2ac831bb762so72804981fa.3
        for <kvm-ppc@vger.kernel.org>; Wed, 10 May 2023 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683728149; x=1686320149;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=YJXjk6aVi7VXIf7ikvzSgJVCb89W4qRYnoj51IJY9BIJaQzucCfDMfE5/tqNh5bNsS
         1IWbx9rLIqiv682pAh2Ku/GkHlYemyzhzze44gX16a66INKQK5fLNBOc98QySLr672wY
         6XroUJzSXm1U56v2Xu0sNCxTMnSMZ8awalQ82PmyBLyU48rLx1edU6JvnVBs4Ndlet12
         7rVH4YjdPIinh1NsRjX37+sGK0yrQnB2wlUBsUA6/1FrlfGQHn2l4zXtBfES9bUtacZt
         heMEKpC7VskaRS4b2/UGlTio4cof80AqMqKJhsEmeR6RNgBjLfi/yhrz3Irk34jieex5
         4qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683728149; x=1686320149;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=eiQtTFycOF3nF6Xr9oJ0iL+GjWXTaFkOGNKqZDHoMkEkrqdiKxII5lOnZK4GSxz99B
         iBNMHdpNtCa218PyKGyt3ZfS630wTBMCw4qZW79ypRF2Bt7GdMzVs9TgyZC6xi9DQ7OD
         p9arJHenj8g4HHXGnRrADCdHlIr3E3pAxCPGyb2s6dOONi38kwLJ+VQxOuIgwVVKhrc7
         7CdCm23LwSADCvVCjHe5ozGp6IKtUfGtSVM7Us1fr/94i6jE4J7IL+uxfORm8UfniX7g
         5dYwm1y0EMqTAWV3d6107gvD/lP695nY1Ur1Z600alixPdH+r5K4+F+/prlFrZ9oljzf
         Nd8A==
X-Gm-Message-State: AC+VfDznvOkhBL/Br5Wxmske28ehzh3Ag3vg3acvD0T0z/PU3dOduP7U
        ynLG0KZrc8qqX/o7EP8Or/4lzTAEJbb5UYb6nbA=
X-Google-Smtp-Source: ACHHUZ4Am0UALeB1lx2TmAs6y6HnM+9P0vlb0VlXaiC/1WlRYQW3rB5GRSUBEnZjcuJG+LqluTkjEmGdEhFh8Le4jL0=
X-Received: by 2002:a2e:350f:0:b0:2ad:8cbd:981a with SMTP id
 z15-20020a2e350f000000b002ad8cbd981amr2223496ljz.35.1683728148438; Wed, 10
 May 2023 07:15:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:98cf:0:b0:2ac:a011:b92d with HTTP; Wed, 10 May 2023
 07:15:47 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <info.ninacoulibaly11@gmail.com>
Date:   Wed, 10 May 2023 07:15:47 -0700
Message-ID: <CAKjR=UQQdmUjPLZ1qz9k8M-cjsDHVQY5-kuLajdYGVN_iSGZww@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
