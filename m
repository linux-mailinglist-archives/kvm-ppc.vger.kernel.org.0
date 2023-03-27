Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2746C9EDC
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Mar 2023 11:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbjC0JEs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 27 Mar 2023 05:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbjC0JEG (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 27 Mar 2023 05:04:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39E4ED5
        for <kvm-ppc@vger.kernel.org>; Mon, 27 Mar 2023 02:03:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eh3so32807395edb.11
        for <kvm-ppc@vger.kernel.org>; Mon, 27 Mar 2023 02:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679907791;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IE0Q22t9nDUcBAUVsmYKmeg+5EtHh5OHc8AXl8b80GM=;
        b=KTeXf5rfD4vjpWQQK16nyr0uP2VOlarPp6TcR+3pwmOjBriTfg6XYZHCStBUeaBUvW
         eF9WtVab2eXfs+75jn/TRHotBatMCnoAh8XRYBqcILuHWHCmlS0OFcPjzUgLD78R9Wj6
         bVziZ8Qi8yuQ5uY0y0PGW0szB+/lrSYur2aF3RmswzjT3FdNiPSadC3nzFPpUgIitIqq
         uU9jQxrR3BhKGWhz06nAdL9wVJqNObI4hwid4UQt3q9B/z/jSDKTaHIUslGkRF9lGDkU
         po7Mfv0u7H2/i+qIgvgDD0leRrmX3eGKaBzBpd9b49t4Jc/V9qERQRl63VsMj6Nh3dUL
         UraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679907791;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IE0Q22t9nDUcBAUVsmYKmeg+5EtHh5OHc8AXl8b80GM=;
        b=vunI1/kOWp729e0rtpkZltI/bMcElXiAPG3AM6MQ66l1SeRZk1KKbzITQ3OBwd4BpS
         jlV+tnFS9Vr/w4OOzQToG16T5xOLxUWi7d+s2j/B+th4zdj+tzJqhJKiJmc+xTl3RvM0
         CiGX8dRPHOnADIkJan3r+4bes2iFJ77J+bp6Co3vEpZj6HdaC2n6K16lLVSAn0Y03erj
         jv0BfFIJkFpbRdJJYOKTmjLXNNrFHamWL1ck+x2kxRIhh9WRKPqr8QpU8WE4NaIVCweE
         M0y1+L8jVrFpVs2qljyqV1cbsEMG15pO5AVZCn4EH8eLidaqSO0VTRbzAcVrdwz4d/HM
         pGOQ==
X-Gm-Message-State: AAQBX9eUKdWJzBl2ihUGsUOOZBU5xANSpDSJtnSMHnyp8lJDbncfIgQz
        6GlDlOAJFJ37Yg23hy0FwnLgGSV8GvEX0B+bB5M=
X-Google-Smtp-Source: AKy350ZD2ESIW02TnCGB9TvafsadwlfYCF6mSKgaGO2EGXA1ya7k8RtgyDUWdLdgzmEByBzu+qLqDRff6xqZbBGOCK4=
X-Received: by 2002:a17:906:b295:b0:87f:e5af:416e with SMTP id
 q21-20020a170906b29500b0087fe5af416emr5317288ejz.7.1679907790855; Mon, 27 Mar
 2023 02:03:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:a397:b0:88b:66b4:3e87 with HTTP; Mon, 27 Mar 2023
 02:03:10 -0700 (PDT)
Reply-To: annamalgorzata587@gmail.com
From:   "Leszczynska Anna Malgorzata." <va3315021@gmail.com>
Date:   Mon, 27 Mar 2023 02:03:10 -0700
Message-ID: <CAJAAtyxpfu+5Jgop=oakHFrU_1rx=msnG4E_4L_g1V4ts-w9UA@mail.gmail.com>
Subject: Mrs. Leszczynska Anna Malgorzata.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.0 required=5.0 tests=ADVANCE_FEE_5_NEW,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52c listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [va3315021[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [va3315021[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [annamalgorzata587[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.8 ADVANCE_FEE_5_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

-- 
I am Mrs. Leszczynska Anna Malgorzatafrom  from Germany Presently
admitted  in one of the hospitals here in Ivory Coast.

I and my late husband do not have any child that is why I am donating
this money to you having known my condition that I will join my late
husband soonest.

I wish to donate towards education and the less privileged I ask for
your assistance. I am suffering from colon cancer I have some few
weeks to live according to my doctor.

The money should be used for this purpose.
Motherless babies
Children orphaned by aids.
Destitute children
Widows and Widowers.
Children who cannot afford education.

My husband stressed the importance of education and the less
privileged I feel that this is what he would have wanted me to do with
the money that he left for charity.

These services bring so much joy to the kids. Together we are
transforming lives and building brighter futures - but without you, it
just would not be possible.

Sincerely,

Mrs. Leszczynska Anna Malgorzata.
