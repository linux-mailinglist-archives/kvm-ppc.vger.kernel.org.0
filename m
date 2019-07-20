Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014F46ED37
	for <lists+kvm-ppc@lfdr.de>; Sat, 20 Jul 2019 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfGTBjb (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 19 Jul 2019 21:39:31 -0400
Received: from ozlabs.ru ([107.173.13.209]:47898 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729002AbfGTBjb (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 19 Jul 2019 21:39:31 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 921C0AE807F5;
        Fri, 19 Jul 2019 21:29:20 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH kernel RFC 0/2] powerpc/pseries: Kexec style boot
Date:   Sat, 20 Jul 2019 11:29:17 +1000
Message-Id: <20190720012919.14417-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is a funny excercise to run a guest under QEMU without
the SLOF firmware and boot into a kernel directly to use petitboot as
a boot loader (a more power boot loader than grub and yum),
the patchset is posted as "spapr: Kexec style boot".

Since there is no SLOF, i.e. no client interface and no RTAS blob,
we need to avoid the former and call the latter directly. Also,
this implements "client-architecture-support" substiitute for
the new environment.

This is based on sha1
a2b6f26c264e Christophe Leroy "powerpc/module64: Use symbolic instructions names.".

Please comment. Thanks.



Alexey Kardashevskiy (2):
  powerpc/pseries: Call RTAS directly
  powerpc/pseries: Kexec style ibm,client-architecture-support support

 arch/powerpc/include/asm/rtas.h |  1 +
 arch/powerpc/kernel/prom_init.c | 12 ++++++---
 arch/powerpc/kernel/rtas.c      | 47 +++++++++++++++------------------
 arch/powerpc/kernel/setup_64.c  | 41 ++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 30 deletions(-)

-- 
2.17.1

