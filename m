Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B34D36EBC4
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Apr 2021 16:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbhD2ODG (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Apr 2021 10:03:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40585 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233602AbhD2ODF (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 29 Apr 2021 10:03:05 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FWHHs754mz9sXM; Fri, 30 Apr 2021 00:02:17 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm-ppc@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>
In-Reply-To: <20210301063653.51003-1-aik@ozlabs.ru>
References: <20210301063653.51003-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel v2] powerpc/iommu: Annotate nested lock for lockdep
Message-Id: <161970488550.4033873.235569973862535887.b4-ty@ellerman.id.au>
Date:   Fri, 30 Apr 2021 00:01:25 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 1 Mar 2021 17:36:53 +1100, Alexey Kardashevskiy wrote:
> The IOMMU table is divided into pools for concurrent mappings and each
> pool has a separate spinlock. When taking the ownership of an IOMMU group
> to pass through a device to a VM, we lock these spinlocks which triggers
> a false negative warning in lockdep (below).
> 
> This fixes it by annotating the large pool's spinlock as a nest lock
> which makes lockdep not complaining when locking nested locks if
> the nest lock is locked already.
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/iommu: Annotate nested lock for lockdep
      https://git.kernel.org/powerpc/c/cc7130bf119add37f36238343a593b71ef6ecc1e

cheers
