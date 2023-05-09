Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A17A6FCA8C
	for <lists+kvm-ppc@lfdr.de>; Tue,  9 May 2023 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbjEIPux (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 May 2023 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbjEIPuw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 May 2023 11:50:52 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F133598
        for <kvm-ppc@vger.kernel.org>; Tue,  9 May 2023 08:50:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a640c23a62f3a-965d2749e2eso825903166b.1
        for <kvm-ppc@vger.kernel.org>; Tue, 09 May 2023 08:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683647450; x=1686239450;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9MgH2yk3oKPfzsyrz/5pM854nV5ZPzia2UxJXZBDwzc=;
        b=NDYPJd2/tKknc4pPRL1B3HBusWIHVdg/aw1ToD3BehslX+j0/7rz+Sd/riCVTiv4FT
         tPw8bSHbOBJHpUN2l6rzqYwtmH1Quk9nVYHafW+ll7CrbN6XbDGiKi7BGkKmHFFS4Ix+
         9tvfGZjGt6+qy9m6Z65vLogGD7B8BjIz0vQ+RrKpn/nCO31xBIEBogDAiq4EaFmN5jsm
         7v12ak2GSMJJTFTcCNC0FNLC8lIw3RlohZ1PshtPsWg9uxLHiRsIyQX9ig8VRaShWmmd
         +FHRrAcxu49n71Ey1uezScazUB2Bt3PNNmKbSZkvlZiH8fP12jhufwQGS/7CKrIAdqHE
         U5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683647450; x=1686239450;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MgH2yk3oKPfzsyrz/5pM854nV5ZPzia2UxJXZBDwzc=;
        b=C6sgifS0MUR8ekUDt6nwUSswPHsi2Ipsgv2OUkPSOUJBy9DebsowVgZwToKW1yDB/5
         2hYLhc9/XiGC6QtUgqy8EaYNGDB7TIbPtE8ZgWLF3mvAEuEBS8OhZWKH0QxYfrhXdo4U
         BkTWm4901kVplFzK+mpWuvQx4NA/z3kFQ2jube+hjTysWdolpCnaL1ZjUCcnA8ZF+r/Z
         kGNpZoqWeLe1CZ0mubKenyPod2Cn/R0P8MAIfJvRpdvcOxoJi7I7Mjlh45v+74skLB0Q
         N8NxvsoWS7rlvXyBW91/XvMTy65L7F9OLZjCs9YW2FQRFiPCp0iW9ords06vZZvRtqN0
         43Ng==
X-Gm-Message-State: AC+VfDw9lpb0F/tbX9sPr+nnVGuTc6p9fJkZbs9f7nYXgPnr5FJ0JV8u
        A8ieaASNDR7aXVlH8RiiqC6WkIvQXWft5iiJcEg=
X-Google-Smtp-Source: ACHHUZ5UP7P7ZQRPtuw+U+zNJeGDQKeeUgqejJysZKPg3BKXt/jFOWddibAPnUJkc6L3Q4BWUFCHJ2qo+BUWPu+QJRI=
X-Received: by 2002:a17:907:5ca:b0:965:6cb9:b768 with SMTP id
 wg10-20020a17090705ca00b009656cb9b768mr10498978ejb.31.1683647449816; Tue, 09
 May 2023 08:50:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:db04:b0:953:7456:30e4 with HTTP; Tue, 9 May 2023
 08:50:49 -0700 (PDT)
Reply-To: rhsheikhalhamed@gmail.com
From:   Abu Dhabi Investment Authority <hagdfcost@gmail.com>
Date:   Tue, 9 May 2023 16:50:49 +0100
Message-ID: <CAGUzCAcvftOYf8muovZU3Z1-v08pZcWrurYxMJMaCqfhkc0WHQ@mail.gmail.com>
Subject: Salam Alaikum /ADIA LOAN OFFER
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:644 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hagdfcost[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear Sir/Madam,

We are a United Arab Emirates based investment company known as Abu
Dhabi Investment Authority working on expanding its portfolio globally
and financing projects.

We are offering Corporate and Personal Loan at 3.5% Interest Rate for
a duration of 5 to 10 years.

Contact us on Email: rhsheikhalhamed@gmail.com ,for more information
and proceeding!

We also give 2% commission to consultants and brokers who introduce
project owners for finance or other opportunities.


Yours truly,
Mahmoud Al Hamoud
(Personal Assistant)
Abu Dhabi Investment Authority
211 Corniche, PO Box 3600
Abu Dhabi,United Arab Emirates
