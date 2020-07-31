Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988952340E2
	for <lists+kvm-ppc@lfdr.de>; Fri, 31 Jul 2020 10:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731524AbgGaILK (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 31 Jul 2020 04:11:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48986 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731510AbgGaILK (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 31 Jul 2020 04:11:10 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V81uqv102565;
        Fri, 31 Jul 2020 04:10:56 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32mfb8gcrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 04:10:56 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V859t6019431;
        Fri, 31 Jul 2020 08:10:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 32gcqk49te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 08:10:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V8ApnT63898038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 08:10:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBDE511C050;
        Fri, 31 Jul 2020 08:10:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E37C211C04C;
        Fri, 31 Jul 2020 08:10:47 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.211.129.132])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jul 2020 08:10:47 +0000 (GMT)
Date:   Fri, 31 Jul 2020 01:10:44 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>, sukadev@linux.ibm.com,
        corbet@lwn.net, linux-doc@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        ldufour@linux.ibm.com, david@gibson.dropbear.id.au,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Define H_PAGE_IN_NONSHARED for
 H_SVM_PAGE_IN hcall
Message-ID: <20200731081044.GA5787@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <alpine.DEB.2.22.394.2007301231140.2548@hadrien>
 <20200730232101.GB5882@oc0525413822.ibm.com>
 <20200731043334.GB20199@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731043334.GB20199@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-30,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=996 adultscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310054
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Jul 31, 2020 at 10:03:34AM +0530, Bharata B Rao wrote:
> On Thu, Jul 30, 2020 at 04:21:01PM -0700, Ram Pai wrote:
> > H_SVM_PAGE_IN hcall takes a flag parameter. This parameter specifies the
> > way in which a page will be treated.  H_PAGE_IN_NONSHARED indicates
> > that the page will be shared with the Secure VM, and H_PAGE_IN_SHARED
> > indicates that the page will not be shared but its contents will
> > be copied.
> 
> Looks like you got the definitions of shared and non-shared interchanged.

Yes. Realized it after sending the patch. Will fix it.

> 
> > 
> > However H_PAGE_IN_NONSHARED is not defined in the header file, though
> > it is defined and documented in the API captured in
> > Documentation/powerpc/ultravisor.rst
> > 
> > Define H_PAGE_IN_NONSHARED in the header file.
> 
> What is the use of defining this? Is this used directly in any place?
> Or, are youp planning to introduce such a usage?

I know the Hypervisor code currently has no use for that define.
It assumes  H_PAGE_IN_NONSHARED to be !H_PAGE_IN_SHARED.

But H_PAGE_IN_NONSHARED is defined in the Ultravisor API, and hence has
to be captured in the header, to stay consistent.

RP
