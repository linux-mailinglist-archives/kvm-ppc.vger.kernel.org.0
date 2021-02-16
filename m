Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93731C5DC
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Feb 2021 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBPDeY (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 15 Feb 2021 22:34:24 -0500
Received: from ozlabs.ru ([107.174.27.60]:48836 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229780AbhBPDeW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 15 Feb 2021 22:34:22 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 20320AE8020D;
        Mon, 15 Feb 2021 22:33:09 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 0/2] powerpc/iommu: Stop crashing the host when VM is terminated
Date:   Tue, 16 Feb 2021 14:33:05 +1100
Message-Id: <20210216033307.69863-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Killing a VM on a host under memory pressure kills a host which is
annoying. 1/2 reduces the chances, 2/2 eliminates panic() on
ioda2.


This is based on sha1
f40ddce88593 Linus Torvalds "Linux 5.11".

Please comment. Thanks.



Alexey Kardashevskiy (2):
  powerpc/iommu: Allocate it_map by vmalloc
  powerpc/iommu: Do not immediately panic when failed IOMMU table
    allocation

 arch/powerpc/kernel/iommu.c               | 19 ++++++-------------
 arch/powerpc/platforms/cell/iommu.c       |  3 ++-
 arch/powerpc/platforms/pasemi/iommu.c     |  4 +++-
 arch/powerpc/platforms/powernv/pci-ioda.c | 15 ++++++++-------
 arch/powerpc/platforms/pseries/iommu.c    | 10 +++++++---
 arch/powerpc/sysdev/dart_iommu.c          |  3 ++-
 6 files changed, 28 insertions(+), 26 deletions(-)

-- 
2.17.1

