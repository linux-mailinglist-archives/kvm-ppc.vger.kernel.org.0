Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A3C36EBC3
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Apr 2021 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhD2ODE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Apr 2021 10:03:04 -0400
Received: from ozlabs.org ([203.11.71.1]:46681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233602AbhD2ODE (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 29 Apr 2021 10:03:04 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FWHHs1hNRz9sXL; Fri, 30 Apr 2021 00:02:17 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     David Gibson <david@gibson.dropbear.id.au>, kvm-ppc@vger.kernel.org
In-Reply-To: <20210216033307.69863-1-aik@ozlabs.ru>
References: <20210216033307.69863-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel 0/2] powerpc/iommu: Stop crashing the host when VM is terminated
Message-Id: <161970488532.4033873.2132452477310887918.b4-ty@ellerman.id.au>
Date:   Fri, 30 Apr 2021 00:01:25 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 16 Feb 2021 14:33:05 +1100, Alexey Kardashevskiy wrote:
> Killing a VM on a host under memory pressure kills a host which is
> annoying. 1/2 reduces the chances, 2/2 eliminates panic() on
> ioda2.
> 
> 
> This is based on sha1
> f40ddce88593 Linus Torvalds "Linux 5.11".
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc/iommu: Allocate it_map by vmalloc
      https://git.kernel.org/powerpc/c/7f1fa82d79947dfabb4046e1d787da9db2bc1c20
[2/2] powerpc/iommu: Do not immediately panic when failed IOMMU table allocation
      https://git.kernel.org/powerpc/c/4be518d838809e21354f32087aa9c26efc50b410

cheers
