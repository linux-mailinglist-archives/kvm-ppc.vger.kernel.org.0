Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97FCF5B54B
	for <lists+kvm-ppc@lfdr.de>; Mon,  1 Jul 2019 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfGAGq5 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 1 Jul 2019 02:46:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727080AbfGAGq4 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 1 Jul 2019 02:46:56 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x616khuF125709
        for <kvm-ppc@vger.kernel.org>; Mon, 1 Jul 2019 02:46:55 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tfc1gb6x4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 01 Jul 2019 02:46:54 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <linuxram@us.ibm.com>;
        Mon, 1 Jul 2019 07:46:53 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 1 Jul 2019 07:46:50 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x616knRb47054894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 06:46:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CBF4AE055;
        Mon,  1 Jul 2019 06:46:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3F10AE045;
        Mon,  1 Jul 2019 06:46:45 +0000 (GMT)
Received: from ram.ibm.com (unknown [9.80.225.192])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 06:46:45 +0000 (GMT)
Date:   Sun, 30 Jun 2019 23:46:42 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     maddy <maddy@linux.vnet.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Anderson <andmike@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20190628200825.31049-1-cclaudio@linux.ibm.com>
 <20190628200825.31049-7-cclaudio@linux.ibm.com>
 <f153b6bf-4661-9dc0-c28f-076fc8fe598e@ozlabs.ru>
 <1e7f702a-c0cd-393d-934e-9e1a1234fe28@linux.vnet.ibm.com>
 <abe23edf-e593-ca98-8047-39ecb6cf16b5@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abe23edf-e593-ca98-8047-39ecb6cf16b5@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19070106-0008-0000-0000-000002F8AC11
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070106-0009-0000-0000-00002265EF11
Message-Id: <20190701064642.GA5009@ram.ibm.com>
Subject: Re:  Re: [PATCH v4 6/8] KVM: PPC: Ultravisor: Restrict LDBAR access
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=18 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010085
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jul 01, 2019 at 04:30:55PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 01/07/2019 16:17, maddy wrote:
> > 
> > On 01/07/19 11:24 AM, Alexey Kardashevskiy wrote:
> >>
> >> On 29/06/2019 06:08, Claudio Carvalho wrote:
> >>> When the ultravisor firmware is available, it takes control over the
> >>> LDBAR register. In this case, thread-imc updates and save/restore
> >>> operations on the LDBAR register are handled by ultravisor.
> >> What does LDBAR do? "Power ISA™ Version 3.0 B" or "User’s Manual POWER9
> >> Processor" do not tell.
> > LDBAR is a per-thread SPR used by thread-imc pmu to dump the counter
> > data into memory.
> > LDBAR contains memory address along with few other configuration bits
> > (it is populated
> > by the thread-imc pmu driver). It is populated and enabled only when any
> > of the thread
> > imc pmu events are monitored.
> 
> 
> I was actually looking for a spec for this register, what is the
> document name?

  Its not a architected register. Its documented in the Power9
  workbook.

RP

