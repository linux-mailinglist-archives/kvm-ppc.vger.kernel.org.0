Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18117016C3
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 May 2023 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjEMMpj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 13 May 2023 08:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjEMMpi (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 13 May 2023 08:45:38 -0400
X-Greylist: delayed 333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 13 May 2023 05:45:36 PDT
Received: from bahamut.mc.pp.se (bahamut-sn.mc.pp.se [213.115.244.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA15A1BE3
        for <kvm-ppc@vger.kernel.org>; Sat, 13 May 2023 05:45:36 -0700 (PDT)
Received: from hakua (hakua [192.168.42.40])
        by bahamut.mc.pp.se (Postfix) with SMTP id 2EE2EA8C2C
        for <kvm-ppc@vger.kernel.org>; Sat, 13 May 2023 14:39:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mc.pp.se; s=hedgehog;
        t=1683981597; bh=aMLQ2LpFtaEL66K30PtMnMeivkgKN7Ociw0/3lhHoM4=;
        h=To:Subject:From:Date:Message-ID:MIME-Version:Content-Type; b=IHQe
        eW59CI/6P+swfeOWc2lrcRp21s8E+hMWEQPnaPcNTMvP+3TlGjEEbNh8T9WD1uO5Tp4
        6CtC1wu/pv6U7E2/WHVErvztiZWu2zwIFfN6pWZi+pxaTUZN4Qaw++6ykItZWgGlXnO
        YCXwVB5LPgopROO5Ld3JDgIa5AeO6nj2Y=
Received: by hakua (sSMTP sendmail emulation); Sat, 13 May 2023 14:39:56 +0200
To:     kvm-ppc@vger.kernel.org
Subject: BE KVM breakage in kernel 5.14 and forward
From:   Marcus Comstedt <marcus@mc.pp.se>
Date:   Sat, 13 May 2023 14:39:55 +0200
Message-ID: <yf9jzxch0bo.fsf@mc.pp.se>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.24 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Greetings!

I'm using a Talos II with dual POWER9 DD2.2 processors in a BE, radix,
64k page config.

When trying to upgrade from 5.4.206 to 6.1.26, I noticed that all my
KVM virtual machines stopped working.  I tried the other stables, and
found that 5.15.111 was also broken, but 5.10.179 was fine.

So I did a bisect between 5.10 and 5.15 and ended up with the
following commit:


  commit 89d35b23910158a9add33a206e973f4227906d3c (HEAD)
  Author: Nicholas Piggin <npiggin@gmail.com>
  Date:   Fri May 28 19:07:34 2021 +1000

      KVM: PPC: Book3S HV P9: Implement the rest of the P9 path in C


In the commit before (9dc2babc185e) everything is working, but from
89d35b2391015 and forward what happens is that any KVM guest will
freeze really early (after the "FW Version = git-6b6c16b4b4076350"
printout from SLOF) running at 100% CPU on a single thread without
progress.  There is no relevant message in dmesg.

I notice that the commit in question seems to make some assumptions
related to the stack frame layout.  BE kernels are always
compiled with -mabi=elfv1 (hardcoded in arch/powerpc/Makefile for
5.14/5.15, then moved to arch/powerpc/platforms/Kconfig.cputype in
6.1); could it be that this code needs to be adjusted depending on the
ELF ABI version?



  // Marcus


