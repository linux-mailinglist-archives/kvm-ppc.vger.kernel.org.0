Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFB46C3FF9
	for <lists+kvm-ppc@lfdr.de>; Wed, 22 Mar 2023 02:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjCVBrR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Mar 2023 21:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCVBrO (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Mar 2023 21:47:14 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C57574C0
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Mar 2023 18:47:13 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j11so21472318lfg.13
        for <kvm-ppc@vger.kernel.org>; Tue, 21 Mar 2023 18:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679449632;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQlu0Oc2Q0nPMBCNq5iTPUZpwrRZlsMdPt2zjra8+VI=;
        b=XJOXfwgyrdrqxPIRIUo5v0SPUTTMf6BMpn93V9icYKySd8NrQkd0EVCl5Ov8onAI7m
         ObgM83XpCM/pv7oLnoboINiyfhMBDFud8Vypc4tlw06WjeG9c97sWYjCdxFm4NbEwHPp
         Sx6QvlfgPyjICLk7woPk2d5wnNHfLtXgBSTKE8EYfHVP08X2//INgS2KB6WBwWTe8mA7
         xlnvDSr3Ho2jnpaWu3NyCKoFpjk9Tgd/UxUUgyocjk2JXQHjKflXKewNg0FOLbc8VC06
         2Nvfw34M7JLyrbqlCSSC4CKlcpBt6bMYwOpzntST2VQSXWDQGR1GXxQmDvUqIWSH9yIE
         IniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679449632;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQlu0Oc2Q0nPMBCNq5iTPUZpwrRZlsMdPt2zjra8+VI=;
        b=IUYOrWyf1NrNY8zHKSDDElDjxo5BVyG8QS2m2MS3rl5TmZ4S+PwVcMmX6+oc5hH41d
         ToSFjAMkuJsUK/aqkCFiFqoB3GunbXN7xKoG6QYXkqOgXG4Fp85qUnPtEmKRp2O2KJT7
         ruHh+pPBZfHhbQOCgC6gKRcu6HNHDrKa7RJ6bYcSWd1rLsELPEE3W4on7Z5rkGw0LrUT
         YNGHZbbWoSBnHMdWmgqPtCrByRi/9c0qQDRa8eSqBSO6dLrKLo4vttZrGQ1r3ZECZ5yJ
         /UMsTjEHfuzI86+TioRXEOAUofgGUFe7S/8pJKW7wMEKi/Mn4JW1xOcSwlniODoGgXm+
         mkcg==
X-Gm-Message-State: AO0yUKVdFKXrx8Mwrmtryn1vJ72+xpjlUdG1G4PoigLegA1S3Iguraae
        gZaWeeXl8oww7besZ04h4m3Tk1dMRWD3psnA+js=
X-Google-Smtp-Source: AK7set+fUrf5erIk+b82VuEIMXE5ki1gKIKuGDXvbJRgTFs+MbLbu1IoWW8QGRrRerX/HBPNmDhagGT3WCpafb2NHnY=
X-Received: by 2002:a05:6512:24c:b0:4e0:822f:9500 with SMTP id
 b12-20020a056512024c00b004e0822f9500mr1458192lfo.12.1679449631484; Tue, 21
 Mar 2023 18:47:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab2:701:0:b0:182:3e2a:d16 with HTTP; Tue, 21 Mar 2023
 18:47:11 -0700 (PDT)
Reply-To: mariamkouame.info@myself.com
From:   Mariam Kouame <contact.mariamkouame2@gmail.com>
Date:   Tue, 21 Mar 2023 18:47:11 -0700
Message-ID: <CADfi1WHBbMhBaUO4N89+9wrtbesOYnnfCbxfoVzz7hKxsMTrAw@mail.gmail.com>
Subject: from mariam kouame
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Dear,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Mariam Kouame
