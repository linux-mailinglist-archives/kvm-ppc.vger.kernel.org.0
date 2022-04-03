Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20984F0C48
	for <lists+kvm-ppc@lfdr.de>; Sun,  3 Apr 2022 21:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346433AbiDCTUk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 3 Apr 2022 15:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351388AbiDCTUj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 3 Apr 2022 15:20:39 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC49FD1
        for <kvm-ppc@vger.kernel.org>; Sun,  3 Apr 2022 12:18:42 -0700 (PDT)
X-Sender-Id: wpengine|x-authuser|248276e101d73445e48e124d1c0950a78c38ce38
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 58DE82A149A
        for <kvm-ppc@vger.kernel.org>; Sun,  3 Apr 2022 19:18:42 +0000 (UTC)
Received: from pod-100037 (unknown [127.0.0.6])
        (Authenticated sender: wpengine)
        by relay.mailchannels.net (Postfix) with ESMTPA id D507E2A0D52
        for <kvm-ppc@vger.kernel.org>; Sun,  3 Apr 2022 19:18:41 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1649013522; a=rsa-sha256;
        cv=none;
        b=ViZd2iC5LW3+jYFSVk2TtuN1cgHFRI4hl4rbsdI3Mr5LpDO4eQAiM5SUV2+vRNBBXoEGEZ
        PI4adqGztTN5hZVgXlRxTNB8K7qSNiQD5/W6tnAeN07UeVTy74XmjrIVNRd9Av01g5orMy
        khgZt/9y0SP8Y+468wuUgogSv4RdsjFjrHHAKQ3/fgHuycEau4IrEzU0bgsW5TdGiQlD59
        h+sR/qPbkCKpI2LNIExpsmVZRiG7RLo0421R4mNStNkgY6/2/B1X3vtdAspkHtqQz1e7r6
        e6c7krp/lZvev3MoPILWLKLRuCDz0tygMaoHTkmHAtsjIDRioVHsR5uf6SVEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1649013522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:dkim-signature; bh=076PhcN8GNvgn3HtbakVj+2GSRN6nzye1ukFXgr6FHQ=;
        b=pODEQ/13gy9S1WgQNDNlVd8SsXGGdPgZLM30CXezH/E+3WvzQaXV6uhsMv9ULuhZiwYTgU
        16rSNtTVMa4zZuGvMjEYSIsYjWXYU/Egess+ks2NqvildHfD1bMah3NozaD3r8kq0Q+JUt
        pwWA230J6Np0oqTTBS++sIuiD4sLhYC9lh3VLEEDfaD3GffsnXsF/d904PfttbbyTaqE0M
        zniV341BQRmfCCPnK/FQ02Yv6ehZ5+lZ3F/Lz++RHp4Xhixym9N3XVTyYxjr43kCGBraIM
        Q/PKJ6msGsImaztpZpdi8004H2KmWP3V34wUNuF2rQUKwmYxDZVZ007ZmRMblg==
ARC-Authentication-Results: i=1;
        rspamd-786f77c8d-txzc2;
        auth=pass smtp.auth=wpengine
 smtp.mailfrom="curator=kennedyarts.org@mail1.wpengine.com"
X-Sender-Id: wpengine|x-authuser|248276e101d73445e48e124d1c0950a78c38ce38
Received: from pod-100037 (171.117.211.130.bc.googleusercontent.com
 [130.211.117.171])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.107.255.190 (trex/6.7.1);
        Sun, 03 Apr 2022 19:18:42 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: wpengine|x-authuser|248276e101d73445e48e124d1c0950a78c38ce38
X-MailChannels-Auth-Id: wpengine
X-Chief-Tank: 13d61dc44b47ab58_1649013522195_3667831040
X-MC-Loop-Signature: 1649013522195:1818845380
X-MC-Ingress-Time: 1649013522195
Received: from pod-100037 (localhost [127.0.0.1])
        by pod-100037 (Postfix) with ESMTP id E137641A35
        for <kvm-ppc@vger.kernel.org>; Sun,  3 Apr 2022 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mail1.wpengine.com;
        s=mx; t=1649013520; bh=076PhcN8GNvgn3HtbakVj+2GSRN6nzye1ukFXgr6FHQ=;
        h=Date:To:Subject:From:From;
        b=g+VpnITfZQ2xgd2OXtFpQs+rU5jHdsa1qFcnueIdH3ErSNXSvzdTYXfYKpMnPp7U9
         GyuMZMkVwN+c7CZIEeIVsRqQ9uAzO5YeGf+o2+VScqqE9OGHuzHbZ5uxgfgm39aCeS
         7YUcXQrfLR4l5188crbXxagVIk1btSDXGlXotroOpaEv9lCuspG86P0ueLI91e/z4K
         iiZJFIGBvl2Z0AsQoToAUcKXMgIgXgJ0ZQpcVuOeZMomMPxmMXgE5pcFjlNBoeykoE
         7lRAsOc6g4yPLIdA4OPT/40xhg4tyzsxB43rXfbVCg6MYyDezET1va8uviZ4Xv/lE/
         4IYAkQbdCxP/Q==
Received: from pod-100037:apache2_74:241 (localhost [127.0.0.1])
        by pod-100037 (Postfix) with SMTP id 4DD264255B
        for <kvm-ppc@vger.kernel.org>; Sun,  3 Apr 2022 17:59:19 +0000 (UTC)
Received: by pod-100037:apache2_74:241 (sSMTP sendmail emulation); Sun, 03 Apr 2022 17:59:19 +0000
Date:   Sun, 03 Apr 2022 17:59:19 +0000
X-AuthUser: 248276e101d73445e48e124d1c0950a78c38ce38
To:     kvm-ppc@vger.kernel.org
Subject: Kennedy Heights Arts Center Artist Application
X-PHP-Originating-Script: 33:process-artist-entry.php
From:   curator@kennedyarts.org
Message-Id: <20220403175919.4DD264255B@pod-100037>
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SHORT_SHORTNER,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLACK,
        URIBL_DBL_ABUSE_REDIR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  1.7 URIBL_BLACK Contains an URL listed in the URIBL blacklist
        *      [URIs: bit.do]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [23.83.209.14 listed in list.dnswl.org]
        *  0.0 URIBL_DBL_ABUSE_REDIR Contains an abused redirector URL listed
        *      in the Spamhaus DBL blocklist
        *      [URIs: bit.do]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_MSPIKE_H3 RBL: Good reputation (+3)
        *      [23.83.209.14 listed in wl.mailspike.net]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        *  1.0 PP_MIME_FAKE_ASCII_TEXT BODY: MIME text/plain claims to be
        *      ASCII but isn't
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        * -0.0 RCVD_IN_MSPIKE_WL Mailspike good senders
        *  2.0 SHORT_SHORTNER Short body with little more than a link to a
        *      shortener
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear ❤️ Katie want to meet you! Click here: http://bit.do/fT3fH?jdi ❤️,

Your artwork submission has been received. You will be notified of acceptance in the next few weeks after the jury process has concluded.

If you have any questions, feel free to contact us at 513.631.4278.

Best regards,

KHAC Curator
