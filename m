Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E323954ED
	for <lists+kvm-ppc@lfdr.de>; Mon, 31 May 2021 07:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhEaFMe (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 31 May 2021 01:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhEaFMe (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 31 May 2021 01:12:34 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4E0C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 30 May 2021 22:10:54 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id q25so8160240pfn.1
        for <kvm-ppc@vger.kernel.org>; Sun, 30 May 2021 22:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:mime-version:message-id
         :content-transfer-encoding;
        bh=PAK5QRH91z+SCdu4kLR38Pqrk3fpvtvISw5Hj9SsWJ0=;
        b=oq5k9ewNsSUbHLRvZgMCB+vJKXOo0oXERnKNr+wVWFftSTq8LTCXHOTWDipsVmWnIt
         nWnXly+209ocRsLTcyoVnZXQk0ZX+/6PUNjduWxXJpVjHLLi2qYSFVKRvP3WaaP+1Sq+
         LfdrebX73vtOfHUV4J3Fry7uaf1h5ETPYk9pzJnXNctF9id7MFkjx/waLPkIt/s+g0un
         C4OmHrzbpMXm2z8V65PXbLQg/hPiRRgKdODp1xd/3KI8xKhDwLZgkEMIHcNOf847APgM
         +hLzE1EGJryc4dfCpmMSheoEChbq2nbnjKnw0Od7Xg4Ovh/degUUQIFanGSSnKeRj5mM
         84yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:mime-version:message-id
         :content-transfer-encoding;
        bh=PAK5QRH91z+SCdu4kLR38Pqrk3fpvtvISw5Hj9SsWJ0=;
        b=p8C32Sf54aayBXggM7rjfkC7bNRXbzqJfVIDpVBZp0LNgWBUk6MoT5ZTCQAcXKudOB
         f30Wq8NZzA6nRLURs6G4b8qJqlH3JGN3sqmVTaKYNQyaWibDuycTwtWvsexGHGjQSy0E
         8ypWQi3GlzsVf6W55WUMbDD5ofnMPNSkw2vKMJIMMI99TXWDvhxDOiyhiQpckUd82aLP
         RP8S/5YTWHkMmzMXA6GoABLS1zfB2qoCpYedulvWrMwnpuD2ARcZ9HckajqMeaI/ePIY
         aVQFi1Pll90LfkbCxwgOI3pTEN8tNQulT3IIna21QRD2MndPp0/aSWqUA/w7stxpunLa
         ZrCQ==
X-Gm-Message-State: AOAM532krF4Eu1MQXFctDoxUEd0pKSxG5WynB6473Y7sN404eE4CIZJ5
        BoJCHEqMjZp7eysjA578b9SAwEAQGxN4+g==
X-Google-Smtp-Source: ABdhPJz3WLaprqRlHSivGpGW7g2Df2bvrcm2q37q1FVoPodDrTe+qx4E6ODXFXRoA7m9Q12agbMvMQ==
X-Received: by 2002:a62:6458:0:b029:2e9:c637:975c with SMTP id y85-20020a6264580000b02902e9c637975cmr5674084pfb.53.1622437853234;
        Sun, 30 May 2021 22:10:53 -0700 (PDT)
Received: from localhost (60-241-69-122.static.tpgi.com.au. [60.241.69.122])
        by smtp.gmail.com with ESMTPSA id h76sm10688227pfe.161.2021.05.30.22.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 22:10:52 -0700 (PDT)
Date:   Mon, 31 May 2021 15:10:47 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: KVM P9 optimisation series
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
MIME-Version: 1.0
Message-Id: <1622436567.2f2wupw6c6.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

I have put my current series here

https://github.com/npiggin/linux/tree/kvm-in-c-new

It contains existing Cify series plus about 50 patches, it's getting=20
fairly stable with both L0 and L1 hypervisors. The aim of the series
is to speed up the P9 entry/exit code and also simplify things where
possible.

It does this in several main ways:

- Rearrange code to optimise SPR accesses. Mainly, avoid scoreboard
  stalls.

- Test SPR values to avoid mtSPRs where possible. mtSPRs are expensive.

- Reduce mftb. mftb is expensive.

- Demand fault certain facilities to avoid saving and/or restoring them
  (at the cost of fault when they are used, but this is mitigated over
  a number of entries, like the facilities when context switching=20
  processes). PM, TM, and EBB so far.

- Defer some sequences that are made just in case a guest is interrupted
  in the middle of a critical section to the case where the guest is
  scheduled on a different CPU, rather than every time (at the cost of
  an extra IPI in this case). Namely the tlbsync sequence for radix with
  GTSE, which is very expensive.

- Reduce barriers, atomics, start shedding some of vcore complexity to
  reduce path length, locking, etc.

So far this speeds up the full entry/exit cycle (measured by guest=20
spinning in 'sc 1' to cause exits, with a host hack make it exit rather
than SIGILL), by about 2x on P9 and more on a P10.

There is some more that can be done (xive optimisation, more complexity
reduction, removing another mftb) but there are not many easy gains left
here. The big thing which is not yet addressed is a light weight exit
that does not switch all context each time. That will take a bit more
design to get working really well, so I prefer to do that over a longer
period perhaps with the help of some realistic workloads. It's very
simple to hack something up to work fast with a few TCE or HPT hcalls
for example, but really we may prefer on balance to do something which
is slightly slower for those but works for other host interrupts like=20
timers, device irqs, IPIs, partition scope page faults, etc.

I will submit this after the first Cify series is accepted into the
powerpc/kvm tree.

Thanks,
Nick
