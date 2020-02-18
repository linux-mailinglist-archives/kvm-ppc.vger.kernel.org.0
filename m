Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF44F1621A1
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Feb 2020 08:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgBRHpx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Feb 2020 02:45:53 -0500
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:37212 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgBRHpx (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 18 Feb 2020 02:45:53 -0500
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id E2ECBAE80014;
        Tue, 18 Feb 2020 02:35:20 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 0/5] powerpc/powenv/ioda: Allow huge DMA window at 4GB
Date:   Tue, 18 Feb 2020 18:36:45 +1100
Message-Id: <20200218073650.16149-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


Here is an attempt to support bigger DMA space for devices
supporting DMA masks less than 59 bits (GPUs come into mind
first). POWER9 PHBs have an option to map 2 windows at 0
and select a windows based on DMA address being below or above
4GB.

This adds the "iommu=iommu_bypass" kernel parameter and
supports VFIO+pseries machine - current this requires telling
upstream+unmodified QEMU about this via
-global spapr-pci-host-bridge.dma64_win_addr=0x100000000
or per-phb property. 4/4 advertises the new option but
there is no automation around it in QEMU (should it be?).

For now it is either 1<<59 or 4GB mode; dynamic switching is
not supported (could be via sysfs).

This is a rebased version of
https://lore.kernel.org/kvm/20191202015953.127902-1-aik@ozlabs.ru/

This is based on sha1
71c3a888cbca Linus Torvalds "Merge tag 'powerpc-5.6-1' of git://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux".

Please comment. Thanks.



Alexey Kardashevskiy (5):
  powerpc/powernv/ioda: Move TCE bypass base to PE
  powerpc/powernv/ioda: Rework for huge DMA window at 4GB
  powerpc/powernv/ioda: Allow smaller TCE table levels
  powerpc/powernv/phb4: Add 4GB IOMMU bypass mode
  vfio/spapr_tce: Advertise and allow a huge DMA windows at 4GB

 arch/powerpc/include/asm/iommu.h              |   2 +
 arch/powerpc/include/asm/opal-api.h           |   9 +-
 arch/powerpc/include/asm/opal.h               |   2 +
 arch/powerpc/platforms/powernv/pci.h          |   2 +-
 include/uapi/linux/vfio.h                     |   2 +
 arch/powerpc/platforms/powernv/npu-dma.c      |   1 +
 arch/powerpc/platforms/powernv/opal-call.c    |   2 +
 arch/powerpc/platforms/powernv/pci-ioda-tce.c |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     | 229 ++++++++++++++----
 drivers/vfio/vfio_iommu_spapr_tce.c           |  10 +-
 10 files changed, 207 insertions(+), 56 deletions(-)

-- 
2.17.1

