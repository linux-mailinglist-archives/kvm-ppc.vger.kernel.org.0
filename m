Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D96116A4F
	for <lists+kvm-ppc@lfdr.de>; Mon,  9 Dec 2019 10:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfLIJ6G (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 9 Dec 2019 04:58:06 -0500
Received: from bahamut-sn.mc.pp.se ([213.115.244.39]:16704 "EHLO
        bahamut.mc.pp.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727113AbfLIJ6G (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 9 Dec 2019 04:58:06 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2019 04:58:04 EST
Received: from hakua (hakua [192.168.42.40])
        by bahamut.mc.pp.se (Postfix) with SMTP id 49AF618714
        for <kvm-ppc@vger.kernel.org>; Mon,  9 Dec 2019 10:52:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mc.pp.se; s=hedgehog;
        t=1575885159; bh=lsGz/gBCKbpDsszZcO3SGRDfS63QEUzijpuiKomHlcU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=0ZF3
        iTdumQuYKPj5ZxRZIBvkJkxImg8BDRacV+Of/HE6NeSLe2Cj7+33VHmgS2eHR0tVPtW
        MT7yFBbTxzk5QrkqObR4ylyBrGSVdYWK7j9jkKCL9i1qx8NiyzSuzGHba+nyxPSsZJS
        4J8jZnKjp8/U7HmR5sTQaQxog7K4CgoHo=
Received: by hakua (sSMTP sendmail emulation); Mon, 09 Dec 2019 10:52:38 +0100
From:   "Marcus Comstedt" <marcus@mc.pp.se>
To:     kvm-ppc@vger.kernel.org
Subject: KVM regression on 64-bit big endian in 5.4
Date:   Mon, 09 Dec 2019 10:52:38 +0100
Message-ID: <yf9d0cxn7vd.fsf@mc.pp.se>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.24 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Hi.

I discovered after upgrading to kernel 5.4 on my Talos II (Power9
Nimbus DD2.2) that KVM didn't work anymore.  The guest would crash
already in SLOF.

After bisecting, I found that the culprit was this commit:

| From 6c85b7bc637b64e681760f62c0eafba2f56745c6 Mon Sep 17 00:00:00 2001
| From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Date: Thu, 22 Aug 2019 00:48:38 -0300
| Subject: powerpc/kvm: Use UV_RETURN ucall to return to ultravisor
| 
| When an SVM makes an hypercall or incurs some other exception, the
| Ultravisor usually forwards (a.k.a. reflects) the exceptions to the
| Hypervisor. After processing the exception, Hypervisor uses the
| UV_RETURN ultracall to return control back to the SVM.

Looking at the diff, this change caught my eye:

- ld r6, VCPU_CR(r4)
+ lwz r0, VCPU_CR(r4)

So the loading of VPU_CR has changed from ld to lwz.  This seems
wrong.  ccr is an unsigned long, and the store to VCPU_CR in the same
file uses std, not stw.  So loading VCPU_CR must be done with ld,
otherwise the result will be wrong (truncated on LE, truncated and
left shifted by 16 bits on BE)...


  // Marcus


