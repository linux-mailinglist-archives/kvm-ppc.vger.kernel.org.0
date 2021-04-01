Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17A4350E80
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 07:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhDAFmL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 01:42:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:56839 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhDAFlt (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 1 Apr 2021 01:41:49 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9sWH6GnSz9sXG; Thu,  1 Apr 2021 16:41:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617255707; bh=ShIYCkm+a+E/L5x1YqUqzLYIUICGsINcpthrkowfw8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rOXIoH3gRGYNgxnxA/tpVV/tYox8MEOCL9nu1DPilZTqVVmSXnnvdtNMx+7hIH0S5
         nLWSjnKd87DLNQqORi/Hmg3hn9VI+eTbQ6gpNVjE5jeOMf1YyHbTNrO2Z4yEnnYTgd
         QXX5HaX7xzF4YLlb5Iqa0CWgG5pPHRlLp7o91vQgWfVhRV2fAxAQmEr3sLW5Qf6K94
         KWoce9JdOiiTO7FK0/KQ7ignqphWdPNLAkNVAIE0Gcz5KFKhID8knvUoD+zMpA4xnl
         P1dpoJt0lt7QhaCDQXYUHgJUNM1IcVUpXouvmNZii9IksIV/CZpoNJcMzymp8RgUpZ
         7WoDLvtYAm3aQ==
Date:   Thu, 1 Apr 2021 15:29:21 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v4 12/46] KVM: PPC: Book3S 64: move KVM interrupt entry
 to a common entry point
Message-ID: <YGVMITBR0CZY1Odc@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-13-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-13-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:31AM +1000, Nicholas Piggin wrote:
> Rather than bifurcate the call depending on whether or not HV is
> possible, and have the HV entry test for PR, just make a single
> common point which does the demultiplexing. This makes it simpler
> to add another type of exit handler.
> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
