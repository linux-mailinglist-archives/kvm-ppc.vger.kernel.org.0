Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D564A546
	for <lists+kvm-ppc@lfdr.de>; Tue, 18 Jun 2019 17:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbfFRPZt (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 18 Jun 2019 11:25:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22282 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728982AbfFRPZt (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 18 Jun 2019 11:25:49 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IFPVPw009237
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 11:25:48 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t71qjjhqu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Tue, 18 Jun 2019 11:25:47 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Tue, 18 Jun 2019 16:25:45 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 16:25:43 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IFPeHA50921594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 15:25:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D95ECA404D;
        Tue, 18 Jun 2019 15:25:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E2FA405D;
        Tue, 18 Jun 2019 15:25:38 +0000 (GMT)
Received: from ram.ibm.com (unknown [9.80.224.136])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 15:25:37 +0000 (GMT)
Date:   Tue, 18 Jun 2019 08:25:35 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>,
        linuxppc-dev@ozlabs.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauermann@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20190606173614.32090-1-cclaudio@linux.ibm.com>
 <20190606173614.32090-5-cclaudio@linux.ibm.com>
 <20190617020632.yywfoqwfinjxs3pb@oak.ozlabs.ibm.com>
 <20190618114701.GH7313@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618114701.GH7313@gate.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19061815-0012-0000-0000-0000032A305C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061815-0013-0000-0000-000021634DF3
Message-Id: <20190618152535.GD10806@ram.ibm.com>
Subject: Re:  Re: [PATCH v3 4/9] KVM: PPC: Ultravisor: Add generic ultravisor call
 handler
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180123
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Jun 18, 2019 at 06:47:01AM -0500, Segher Boessenkool wrote:
> Hi Paul,
> 
> On Mon, Jun 17, 2019 at 12:06:32PM +1000, Paul Mackerras wrote:
> > The thing we need to consider is that when SMFCTRL[E] = 0, a ucall
> > instruction becomes a hcall (that is, sc 2 is executed as if it was
> > sc 1).  In that case, the first argument to the ucall will be
> > interpreted as the hcall number.  Mostly that will happen not to be a
> > valid hcall number, but sometimes it might unavoidably be a valid but
> > unintended hcall number.
> 
> Shouldn't a caller of the ultravisor *know* that it is talking to the
> ultravisor in the first place?  And not to the hypervisor.

It may or may not.  But if it knows and still decides to make the ucall,
   the hypervisor must gracefully handle it.  
   
 We can't control who makes a ucall. A normal process within the VM could
 make a ucall too. Or a normal process running on top of the hypervisor
 could make a ucall.

RP

