Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9208114D4E2
	for <lists+kvm-ppc@lfdr.de>; Thu, 30 Jan 2020 01:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgA3A55 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 29 Jan 2020 19:57:57 -0500
Received: from ozlabs.org ([203.11.71.1]:45935 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgA3A55 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 29 Jan 2020 19:57:57 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 487MQp4Grqz9sPJ; Thu, 30 Jan 2020 11:57:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1580345874; bh=cLi5tM1BMtilA/vHH/CQVN7hgfSskkEy3hdkrh98I+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N5jpmvP4TULhdTK2lFayAFzhtWvqu4skpK08K2tsQKFOMh+jEMzO/b7Uf/r8uja8M
         vHwTQJK9iPKJePC20g3ebKU60udAJPvTvcEnoHGaUa//JPDLHGBeYkZkBKMOAIHrZJ
         KCyDLjo8DMO9rouCFZbCHcT3EZt2m1bUKYCdKgU9fvTI5IqjRAd4NgPttnuc/9otHH
         WWISoIOU2qYR/FAwKX/016tghqYA9mZPorzxJ8uvU3DXkHCLZwtIFBt1Fta4SbQvVe
         yBZIQQg6Fd1cnA3sSbrElB1lpVURfNyL1iugAa3ePTs1glhnFXojSArmpqzJQhWIqi
         7bNKwXuynRiqQ==
Date:   Thu, 30 Jan 2020 11:55:20 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        paulus@au1.ibm.com
Subject: Re: [PATCH FIX] KVM: PPC: Book3S HV: Release lock on page-out
 failure path
Message-ID: <20200130005520.GB25802@blackberry>
References: <20200122045542.3527-1-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122045542.3527-1-bharata@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Jan 22, 2020 at 10:25:42AM +0530, Bharata B Rao wrote:
> When migrate_vma_setup() fails in kvmppc_svm_page_out(),
> release kvm->arch.uvmem_lock before returning.
> 
> Fixes: ca9f4942670 ("KVM: PPC: Book3S HV: Support for running secure guests")
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Thanks, applied to my kvm-ppc-next branch.

Paul.
