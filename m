Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3634C80B7
	for <lists+kvm-ppc@lfdr.de>; Tue,  1 Mar 2022 03:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiCACFc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 28 Feb 2022 21:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiCACFc (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 28 Feb 2022 21:05:32 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB8C37
        for <kvm-ppc@vger.kernel.org>; Mon, 28 Feb 2022 18:04:52 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p17so12263736plo.9
        for <kvm-ppc@vger.kernel.org>; Mon, 28 Feb 2022 18:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=g3zInLv5ds2RuDKGbgC05xi/rIjpgE6pPSCRxfaRggQ=;
        b=bjiIixIjn1KLzC9CfAxeeyxjFKzl6pQLqBM5GB61pyZvc/rQoLrFDcltnDYAEBiZUL
         ZbsgErDQe9HAJWXJ/HE7+6cYnKz1BDUWomD9bz76wiwgooN1rtyv7tRM/N/HKi8OrH+r
         TB+pQp6cQ2qF1IuFnZb59fpz5rRugTSXrAJrOGlRtLkEP6HEeWiw3m88y/eBdgI0srqk
         Sp+Yq11nMkzsnRirfLTGxCMElBpey97xVqIAUUUjTZZOgygC4wCtgooS3/yNw5/VcTTo
         cGwR90IM5rQeUlKdPxseLbpHchvWOWtCS67MoZU8TFmOXcxqa12Ue28XMq/5mQRY6hco
         +yWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=g3zInLv5ds2RuDKGbgC05xi/rIjpgE6pPSCRxfaRggQ=;
        b=RlRHDw7ZM4wxO/e+R/Hdizm6SOSek9R99nh3y6pvp5DARmetZQdluPZUX8PYP/jCuq
         iSkWxg5eG2sMddTt1tgzCrMgNkDcPzy83HSE4qaYw6oYg5TmBgNpJt3BMI19KrZhXRNZ
         IM+NOxA9WMgNzy64T252BHZEBL6jXTyXQ+NacX7yAVvkqV3ei66Sl2fstSdbnXcLRYs4
         t9Me1TtdopY7lVbihQ2FIRY8529OVRcG9kr4WA2E2PGvTX2wCi0dnWAV8sOE181BHt9W
         68u4IB5xfAlBrAKbnUDBWeU/lw9C98mS5AKPp88OQWt+10g7vxGOC1c7gz0oBR2l8gX7
         KWkQ==
X-Gm-Message-State: AOAM5306CJM3vIqIwFDtBCXWvj+DpcA073C1mcXWxxwNSd1OVmTtY86k
        PkzqmeojcdmtBBuv+5hJcfpj41E08Lyxjz6Koaw=
X-Google-Smtp-Source: ABdhPJxAl0iPvW459dvSgLd7AbLKlM+X6JYgegS9z1MuFq4Bm3Qp/1Bp5okpPFjoULEHb8qbanFMbk1a9Pffe3n4M4M=
X-Received: by 2002:a17:902:ab52:b0:14d:7ce1:8d66 with SMTP id
 ij18-20020a170902ab5200b0014d7ce18d66mr23318723plb.88.1646100291124; Mon, 28
 Feb 2022 18:04:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:522:8e13:b0:434:e9c6:5cae with HTTP; Mon, 28 Feb 2022
 18:04:49 -0800 (PST)
Reply-To: redcrosssociety@hellokitty.com
In-Reply-To: <CAFS1_r2wGQhjLDE3kGF=3uc6YmkTuZRbEXODdL83WWW7Jsvu-A@mail.gmail.com>
References: <CAFS1_r2wGQhjLDE3kGF=3uc6YmkTuZRbEXODdL83WWW7Jsvu-A@mail.gmail.com>
From:   "Mr. Ewen Stevenson" <carlos2019sonangol@gmail.com>
Date:   Tue, 1 Mar 2022 04:04:49 +0200
Message-ID: <CAFS1_r3tsVhKzfa1+qizQUoge+JwEvAzd9qQG7iK=r-nzC_=KQ@mail.gmail.com>
Subject: Your Compensation Fund.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.8 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY,URG_BIZ,XFER_LOTSA_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:636 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [carlos2019sonangol[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.6 URG_BIZ Contains urgent matter
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_SCAM No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  3.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 ADVANCE_FEE_4_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I am Mr. Ewen Stevenson Group Chief Financial Officer from HSBC Bank
of United Kingdom in Manchester. I was directed by HSBC Bank of UK in
collaboration with United Nation to pay the sum of =C2=A31,500,000.00 (One
Million Five Hundred Thousand Pounds) to you as your Compensation Fund
due to Covid-19 pandemic and other transaction you were engaged in the
past and spent your hard earn money, efforts and finally did not
receive the fund.

Kindly respond to this message in other to direct you on how you will
receive the fund by Bank Wire Transfer to any of your nominated bank
account within 5 working days without any further delay.

I look forward to receiving your urgent response. Call or WhatsApp me
on the below phone number.

Email: redcrosssociety@hellokitty.com
Telephone: +44-745-127-4775
Regards
Mr. Ewen Stevenson
(Group Chief Financial Officer)
England United Kingdom
