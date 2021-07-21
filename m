Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7403D09E6
	for <lists+kvm-ppc@lfdr.de>; Wed, 21 Jul 2021 09:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhGUHAl (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 21 Jul 2021 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235390AbhGUG77 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 21 Jul 2021 02:59:59 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8CC061574
        for <kvm-ppc@vger.kernel.org>; Wed, 21 Jul 2021 00:39:14 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4GV6sX4B2Gz9sXJ; Wed, 21 Jul 2021 17:39:12 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
In-Reply-To: <20210716024310.164448-1-npiggin@gmail.com>
References: <20210716024310.164448-1-npiggin@gmail.com>
Subject: Re: [PATCH 1/2] KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
Message-Id: <162685313071.1066498.453375758692637604.b4-ty@ellerman.id.au>
Date:   Wed, 21 Jul 2021 17:38:50 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 16 Jul 2021 12:43:09 +1000, Nicholas Piggin wrote:
> When running CPU_FTR_P9_TM_HV_ASSIST, HFSCR[TM] is set for the guest
> even if the host has CONFIG_TRANSACTIONAL_MEM=n, which causes it to be
> unprepared to handle guest exits while transactional.
> 
> Normal guests don't have a problem because the HTM capability will not
> be advertised, but a rogue or buggy one could crash the host.

Applied to powerpc/fixes.

[1/2] KVM: PPC: Book3S: Fix CONFIG_TRANSACTIONAL_MEM=n crash
      https://git.kernel.org/powerpc/c/bd31ecf44b8e18ccb1e5f6b50f85de6922a60de3
[2/2] KVM: PPC: Fix kvm_arch_vcpu_ioctl vcpu_load leak
      https://git.kernel.org/powerpc/c/bc4188a2f56e821ea057aca6bf444e138d06c252

cheers
